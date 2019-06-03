#!/bin/bash

#####################################
# Checking Inputs ...
#####################################

if [ ! -z "$(git status -s)" ]; then
    echo "error: uncommitted changes are exists ..."
    exit 1
fi

usage () {
    echo "usage: $(basename $0) [optional:sha]"
    exit 1
}

# By default take last commit from andrzej-tests-1 branch (last commits from master branch is not choosen because of actual issue:
# https://forum.sentry.io/t/enhancement-configs-not-found-on-latest-branches/6800)
if [ $# -eq 0 ]; then
    set -- "$(curl -sSL 'https://api.github.com/repos/andrzej-tests-1/sentry.app/git/refs/heads/andrzej-tests-1' | awk -F '"' '$2 == "sha" { print $4 }')"
    echo "No sha specified, using refs/head/master ($1)"
fi

if [[ $1 =~ ^[a-f0-9]{40}$ ]]; then
        SHA=$1
    else
        usage
fi

set -e
set -x
set -u

#####################################
# Building and store images ...
#####################################

PROJECT=$(basename -s .git "$(git config --get remote.origin.url)")
BRANCHNAME=$(git rev-parse --abbrev-ref HEAD)
VERSION="$(echo $SHA | cut -c -8)"
DOCKERIMAGEPREFIX="eu.gcr.io/$CLOUDSDK_CORE_PROJECT/$PROJECT"

cd "$(git rev-parse --show-toplevel)"/docker-sentry

docker build --build-arg SENTRY_BUILD=$SHA --rm -t $DOCKERIMAGEPREFIX/$BRANCHNAME:$VERSION git
docker push $DOCKERIMAGEPREFIX/$BRANCHNAME:$VERSION

docker tag $DOCKERIMAGEPREFIX/$BRANCHNAME:$VERSION $DOCKERIMAGEPREFIX/$BRANCHNAME:latest
docker push $DOCKERIMAGEPREFIX/$BRANCHNAME:latest
