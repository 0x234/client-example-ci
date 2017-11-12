#!/bin/bash

set -e

docker build -f client.dockerfile -t eu.gcr.io/true-energy-185810/client:$TRAVIS_COMMIT .

echo $GCLOUD_SERVICE_KEY_STG | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json

gcloud --quiet config set project tokencard
gcloud --quiet config set container/cluster tokencard
gcloud --quiet config set compute/zone europe-west1-b
gcloud --quiet container clusters get-credentials $CLUSTER_NAME_STG

gcloud docker push eu.gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}

yes | gcloud beta container images add-tag gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}:$TRAVIS_COMMIT gcr.io/${PROJECT_NAME_STG}/${DOCKER_IMAGE_NAME}:latest

kubectl config view
kubectl config current-context

kubectl set image deployment/client-deployment client=eu.gcr.io/true-energy-185810/client:$TRAVIS_COMMIT
