#!/bin/bash

#####################################
# Checking Inputs ...
#####################################

usage () {
    echo "usage: $(basename $0) [optional:sha]"
    exit 1
}

if [ $# -eq 0 ]; then
    VERSION="latest"
    echo "No sha specified, using 'latest' tag"
elif
    [[ $1 =~ ^[a-f0-9]{40}$ ]]; then
        SHA=$1
    else
        usage
fi

if [ "$VERSION" != "latest" ]; then
    VERSION="$(echo $SHA | cut -c -8)"
fi

set -x
set -e
set -u

#####################################
# Deploying ...
#####################################

PROJECT=$(basename -s .git "$(git config --get remote.origin.url)")
BRANCHNAME=$(git rev-parse --abbrev-ref HEAD)
DOCKERIMAGEPREFIX="eu.gcr.io/$CLOUDSDK_CORE_PROJECT/$PROJECT"

gcloud container clusters get-credentials $CLUSTER_NAME --zone "$CLUSTER_ZONE"

helm install $(git rev-parse --show-toplevel)/helm-sentry --debug --name=$PROJECT-$VERSION-$RANDOM --set image.repository=$DOCKERIMAGEPREFIX,image.tag=$VERSION,ingress.enabled=true -f $(git rev-parse --show-toplevel)/helm-sentry/fix-known-issue.yaml --wait

