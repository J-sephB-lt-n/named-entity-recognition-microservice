# named-entity-recognition-microservice

An example of an API which extracts named entities from a provided user query.

I have not load tested it at all yet.

Deploy it on a google Cloud Run service as follows:

```bash
GCP_PROJ_ID='your-gcp-proj-id'
GCP_REGION='europe-west2'
CREATE_ARTIFACT_REG_REPO_NAME='your-artifact-registry-repo-name'
CREATE_CLOUD_RUN_SERVICE_NAME='named-entity-recognition-test'

gcloud auth login
gcloud config set project $GCP_PROJ_ID # verify with `gcloud config get project`
gcloud config set run/region $GCP_REGION # verify with `gcloud config get run/region`

DOCKER_IMG_URI="${GCP_REGION}-docker.pkg.dev/${GCP_PROJ_ID}/${CREATE_ARTIFACT_REG_REPO_NAME}/${CREATE_CLOUD_RUN_SERVICE_NAME}"

make create_artifact_registry_repo \
  ARTIFACT_REG_REPO_NAME=$CREATE_ARTIFACT_REG_REPO_NAME \
  GCP_REGION=$GCP_REGION \
  CLOUD_RUN_SERVICE_NAME=$CREATE_CLOUD_RUN_SERVICE_NAME

make build \
  DOCKER_IMG_URI=$DOCKER_IMG_URI

make deploy \
  CLOUD_RUN_SERVICE_NAME=$CREATE_CLOUD_RUN_SERVICE_NAME \
  DOCKER_IMG_URI=$DOCKER_IMG_URI
```
