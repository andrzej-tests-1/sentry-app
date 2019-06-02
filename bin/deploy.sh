#!/bin/bash

#####################################
# Checking Inputs ...
#####################################

set -x

usage () {
    echo "usage: $(basename $0) [optional:sha]"
    exit 1
}

if [ $# -eq 0 ]; then
    TAG="latest"
    echo "No sha specified, using 'latest' tag"
elif
    [[ $1 =~ ^[a-f0-9]{40}$ ]]; then
        TAG=$1
    else
        usage
fi

set -e
set -u

#####################################
# Deploying ...
#####################################

PROJECT=$(basename -s .git "$(git config --get remote.origin.url)")
BRANCHNAME=$(git rev-parse --abbrev-ref HEAD)
VERSION="$(git rev-parse --short=8 HEAD)"
DOCKERIMAGEPREFIX="eu.gcr.io/$CLOUDSDK_CORE_PROJECT/$PROJECT"

gcloud container clusters get-credentials $CLUSTER_NAME --zone "$CLUSTER_ZONE"

helm install $(git rev-parse --show-toplevel)/helm-sentry --debug --name=$PROJECT-$VERSION-$RANDOM --set image.repository=$DOCKERIMAGEPREFIX/$BRANCHNAME,image.tag=$TAG,ingress.enabled=true -f $(git rev-parse --show-toplevel)/helm-sentry/fix-known-issue.yaml --wait

