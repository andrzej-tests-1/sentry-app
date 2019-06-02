#!/bin/bash

set -e

usage () {
    echo "usage: $0 <sha>"
    exit 1
}

if [ "$#" = 0 ]; then
    set -- "$(curl -sSL 'https://api.github.com/repos/andrzej-tests-1/sentry.app/git/refs/heads/master' | awk -F '"' '$2 == "sha" { print $4 }')"
    echo "No sha specified, using refs/head/master ($1)"
fi

[[ "$#" = 1 ]] || usage

sha="$1"
[[ $sha =~ ^[a-f0-9]{40}$ ]] || usage

set -x

cd ../docker-sentry
docker build --build-arg SENTRY_BUILD=$sha --rm -t sentry:git git
docker build --rm -t sentry:git-onbuild git/onbuild

docker tag sentry:git andrzejtests/test1:$sha
docker push andrzejtests/test1:$sha
