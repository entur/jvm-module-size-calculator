#!/bin/bash
set -e
if [ "$#" -eq 0 ]; then
  echo "Usage: ./customAppImageDockerBuild.sh <Base image> <Output image>"
  echo
  echo "Example: ./customAppImageDockerBuild.sh myCustomBaseImage:1.0.0 myAppImage:1.0.0"
  exit 1
fi

CUSTOM_BASE_IMAGE=$1
CUSTOM_IMAGE=$2

echo "Build $CUSTOM_IMAGE from $CUSTOM_BASE_IMAGE"

docker build --build-arg CUSTOM_BASE_IMAGE=${CUSTOM_BASE_IMAGE} -f customAppImageDockerfile -t "$CUSTOM_IMAGE" . --progress=plain

echo "Built $CUSTOM_IMAGE"
