gcloud resource-manager folders add-iam-policy-binding XXX \
    --member="serviceAccount:terraform-admin@terraform-backend-XXX.iam.gserviceaccount.com" \
    --role="roles/resourcemanager.folderViewer"
