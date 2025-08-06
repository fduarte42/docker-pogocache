#!/usr/bin/env bash

REPO="tidwall/pogocache"
GITHUB_API="https://api.github.com/repos/${REPO}/tags"
LATEST_TAG="$(curl -s "${GITHUB_API}" | jq -r '.[0].name')"

function tag_args() {
  local TAG="$1"

  if [ "$GITHUB_ACTIONS" = "true" ]; then
    echo "-t ghcr.io/fduarte42/pogocache:$TAG -t docker.io/fduarte42/docker-pogocache:$TAG"
  else
    echo "-t fduarte42/docker-php:$TAG"
  fi
}

if [[ -z "${LATEST_TAG}" ]]; then
    echo "no tag found"
    exit 1
fi

docker buildx build \
    --no-cache \
    --pull \
    --push \
    --platform=linux/amd64,linux/arm64 \
    --build-arg TAG="${LATEST_TAG}" \
    $(tag_args latest) \
    $(tag_args $LATEST_TAG) \
    .
