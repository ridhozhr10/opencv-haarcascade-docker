#!/usr/bin/env bash

imageName="alpine-haarcascade"
imageTag="1.0.0"
targetRepo="ridhozhr"

target=${targetRepo}/${imageName}:${imageTag}

sudo docker buildx build --platform linux/amd64,linux/arm/v7 \
  -t ${target} --push .
