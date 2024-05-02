#!/bin/bash

# Check if a token code is provided as the first argument
if [ -z "$1" ]; then
    echo "Usage: $0 <MFA_TOKEN_CODE>"
    exit 1
fi

# Set the AWS profile environment variable
export AWS_PROFILE=prod-admin

# Get the AWS session token using the provided MFA token code and parse the credentials
CREDENTIALS=$(aws sts get-session-token --serial-number arn:aws:iam::xxx:mfa/SE --token-code $1 --query 'Credentials' --output text)

# Extract individual values
AccessKeyId=$(echo $CREDENTIALS | cut -f1)
SecretAccessKey=$(echo $CREDENTIALS | cut -f2)
SessionToken=$(echo $CREDENTIALS | cut -f3)

# Update the AWS credentials file for the prod-admin-mfa profile
# Backup the original credentials file
cp ~/.aws/credentials ~/.aws/credentials.backup

# Use awk to replace the existing credentials in the profile
awk -v accessKeyId="$AccessKeyId" -v secretAccessKey="$SecretAccessKey" -v sessionToken="$SessionToken" '
    BEGIN {printMode=1}
    /^\[prod-admin-mfa\]/ {print; printMode=0; next}
    /^\[/ {printMode=1}
    printMode==0 && /^aws_access_key_id/ {print "aws_access_key_id=" accessKeyId; next}
    printMode==0 && /^aws_secret_access_key/ {print "aws_secret_access_key=" secretAccessKey; next}
    printMode==0 && /^aws_session_token/ {print "aws_session_token=" sessionToken; next}
    printMode==1 {print}
' ~/.aws/credentials > ~/.aws/credentials.tmp

# Replace the credentials file with the updated one
mv ~/.aws/credentials.tmp ~/.aws/credentials

export AWS_PROFILE=prod-admin-mfa

echo "Updated AWS credentials for profile prod-admin-mfa"
