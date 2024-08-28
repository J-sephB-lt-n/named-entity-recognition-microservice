create_artifact_registry_repo:
  @clear
  gcloud artifacts repositories create $(ARTIFACT_REG_REPO_NAME) \
    --repository-format docker \
    --location $(GCP_REGION) \
    --description='Container image used by Cloud Run Service $(CLOUD_RUN_SERVICE_NAME)'
  gcloud artifacts repositories set-cleanup-policies $(ARTIFACT_REG_REPO_NAME) \
    --policy cleanup_policy_artifact_registry.json \
    --location=$(GCP_REGION)

build:
  @clear
  @echo $$(date +"%Y-%m-%d %H:%M:%S")' Started Docker image build (and push to artifact registry)'
  gcloud builds submit --tag '$(DOCKER_IMG_URI)'
  @echo $$(date +"%Y-%m-%d %H:%M:%S")' Finished Docker image build (and push to artifact registry)'

deploy:
  @clear
  @echo $$(date +"%Y-%m-%d %H:%M:%S")' Started deploying Cloud Run service'
  gcloud run deploy $(CLOUD_RUN_SERVICE_NAME) \
    --image '$(DOCKER_IMG_URI)' \
    --max-instances 1 \
    --min-instances 0 \
    --allow-unauthenticated \
    --timeout 30
  @echo $$(date +"%Y-%m-%d %H:%M:%S")' Finished deploying Cloud Run service'
