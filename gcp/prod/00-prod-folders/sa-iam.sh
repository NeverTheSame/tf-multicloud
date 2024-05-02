gcloud projects add-iam-policy-binding production \
  --member="serviceAccount:terraform-admin@terraform-backend-XXX.iam.gserviceaccount.com" \
  --role='roles/iam.serviceAccountUser'

# Ensure the Service Usage API is Enabled
gcloud services enable serviceusage.googleapis.com --project=production

gcloud projects add-iam-policy-binding production \
  --member="serviceAccount:terraform-admin@terraform-backend-XXX.iam.gserviceaccount.com" \
  --role='roles/serviceusage.serviceUsageConsumer'

gcloud resource-manager folders add-iam-policy-binding XXX \
  --member="serviceAccount:terraform-admin@terraform-backend-XXX.iam.gserviceaccount.com" \
  --role='roles/resourcemanager.folderAdmin'


gcloud projects add-iam-policy-binding production \
  --member="serviceAccount:terraform-admin@terraform-backend-XXX.iam.gserviceaccount.com" \
  --role='roles/editor'

gcloud projects add-iam-policy-binding production \
  --member="serviceAccount:terraform-admin@terraform-backend-XXX.iam.gserviceaccount.com" \
  --role='roles/resourcemanager.ProjectDeleter'

gcloud projects add-iam-policy-binding production \
  --member="serviceAccount:terraform-admin@terraform-backend-XXX.iam.gserviceaccount.com" \
  --role='roles/owner'

gcloud iam roles create CustomProjectDeleter \
  --project=production \
  --title="Custom Project Deleter" \
  --description="Custom role for deleting projects" \
  --permissions=resourcemanager.projects.delete


gcloud projects add-iam-policy-binding production \
  --member="serviceAccount:terraform-admin@terraform-backend-XXX.iam.gserviceaccount.com" \
  --role=projects/production/roles/CustomProjectDeleter


gcloud resource-manager folders add-iam-policy-binding XXX \
  --member="serviceAccount:terraform-admin@terraform-backend-XXX.iam.gserviceaccount.com" \
  --role='roles/resourcemanager.folderAdmin'

gcloud resource-manager folders add-iam-policy-binding XXX \
  --member="serviceAccount:terraform-admin@terraform-backend-XXX.iam.gserviceaccount.com" \
  --role='roles/resourcemanager.folderAdmin'


export GOOGLE_APPLICATION_CREDENTIALS="../../credentials/terraform-backend-XXX-XXX.json"
