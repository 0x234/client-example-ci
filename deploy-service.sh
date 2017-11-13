#!/bin/bash

set -e

echo "Building docker image"
docker build -f client.dockerfile -t eu.gcr.io/true-energy-185810/client:$TRAVIS_COMMIT .

echo "Decoding base64 for gcloud authentication"

echo $GCLOUD_SERVICE_KEY_STG | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json

echo "Setting gcloud config"

gcloud --quiet config set project tokencard
gcloud --quiet config set container/cluster tokencard
gcloud --quiet config set compute/zone europe-west1-b
gcloud --quiet container clusters get-credentials $CLUSTER_NAME_STG

echo "Push docker image to the gcloud registry"

gcloud docker push eu.gcr.io/true-energy-185810/client

echo "Add latest tag to this build"

yes | gcloud beta container images add-tag eu.gcr.io/true-energy-185810/client:$TRAVIS_COMMIT eu.gcr.io/true-energy-185810/client::latest

echo "View cluster info"

kubectl config view
kubectl config current-context

echo "Set image to be the new build"

kubectl set image deployment/client-deployment client=eu.gcr.io/true-energy-185810/client:$TRAVIS_COMMIT
