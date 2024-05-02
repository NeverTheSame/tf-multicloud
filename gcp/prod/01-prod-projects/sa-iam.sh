gcloud beta billing accounts add-iam-policy-binding "billingAccounts/XXX" \
    --member="serviceAccount:terraform-admin@terraform-backend-XXX.iam.gserviceaccount.com" \
    --role="roles/billing.user"

gcloud organizations add-iam-policy-binding XXX \
  --member="serviceAccount:terraform-admin@terraform-backend-XXX.iam.gserviceaccount.com" \
  --role=roles/resourcemanager.projectCreator

gcloud projects add-iam-policy-binding production \
  --member="serviceAccount:testpoc@production.iam.gserviceaccount.com" \
  --role="roles/compute.networkViewer"

gcloud config set project production
gcloud projects add-iam-policy-binding production \
  --member="serviceAccount:testpoc@production.iam.gserviceaccount.com" \
  --role="roles/compute.networkViewer"

gcloud projects add-iam-policy-binding production \
  --member="serviceAccount:testpoc@production.iam.gserviceaccount.com" \
  --role='roles/compute.networkViewer'

gcloud projects add-iam-policy-binding production \
    --member=serviceAccount:veeambackupXXX@production.iam.gserviceaccount.com \
    --role=roles/cloudkms.admin

gcloud projects add-iam-policy-binding production \
    --member=serviceAccount:veeambackupXXX@production.iam.gserviceaccount.com \
    --role=roles/storage.admin

gcloud projects add-iam-policy-binding production \
    --member=serviceAccount:veeambackupXXX@production.iam.gserviceaccount.com \
    --role roles/compute.admin
