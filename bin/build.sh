#!/bin/bash

if [ ! -z "$(git status -s)" ]; then
    echo "error: uncommitted changes are exists ..."
    exit 1
fi

usage () {
    echo "usage: $(basename $0) [optional:sha]"
    exit 1
}

set -e
set -x
set -u

# By default take last commit top andrzej-tests-1 branch (last commits from master branch is not choosen because actual issue:
# https://forum.sentry.io/t/enhancement-configs-not-found-on-latest-branches/6800)
if [ $# -eq 0 ]; then
    set -- "$(curl -sSL 'https://api.github.com/repos/andrzej-tests-1/sentry.app/git/refs/heads/andrzej-tests-1' | awk -F '"' '$2 == "sha" { print $4 }')"
    echo "No sha specified, using refs/head/master ($1)"
fi

[[ $# -eq 1 ]] || usage

sha="$1"
[[ $sha =~ ^[a-f0-9]{40}$ ]] || usage

PROJECT=$(basename -s .git "$(git config --get remote.origin.url)")
BRANCHNAME=$(git rev-parse --abbrev-ref HEAD)
VERSION="$(git rev-parse --short=8 HEAD)"
DOCKERIMAGEPREFIX="eu.gcr.io/$CLOUDSDK_CORE_PROJECT/$PROJECT"

cd "$(git rev-parse --show-toplevel)"/docker-sentry

docker build --build-arg SENTRY_BUILD=$sha --rm -t $DOCKERIMAGEPREFIX/$BRANCHNAME:$VERSION git
docker push $DOCKERIMAGEPREFIX/$BRANCHNAME:$VERSION

docker tag $DOCKERIMAGEPREFIX/$BRANCHNAME:$VERSION $DOCKERIMAGEPREFIX/$BRANCHNAME:latest
docker push $DOCKERIMAGEPREFIX/$BRANCHNAME:latest
