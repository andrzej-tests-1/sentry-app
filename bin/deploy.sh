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

#####################################
# Deploying ...
#####################################

PROJECT=$(basename -s .git "$(git config --get remote.origin.url)")
DOCKERIMAGEPREFIX="eu.gcr.io/$CLOUDSDK_CORE_PROJECT/$PROJECT"
RANDOMID=$RANDOM

set -x
set -e
set -u

gcloud container clusters get-credentials $CLUSTER_NAME --zone "$CLUSTER_ZONE"

helm install $(git rev-parse --show-toplevel)/helm-sentry --debug --name=$PROJECT-$VERSION-$RANDOMID --set image.repository=$DOCKERIMAGEPREFIX,image.tag=$VERSION,ingress.enabled=true -f $(git rev-parse --show-toplevel)/helm-sentry/fix-known-issue.yaml --wait

# env for for Jenkins next stages ...
echo "export RANDOMID=$RANDOMID ; export PROJECT=$PROJECT ; export VERSION=$VERSION" > $(git rev-parse --show-toplevel)/envrandom
