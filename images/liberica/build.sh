#!/bin/bash
set -e

if [ "$#" -eq 0 ]; then
  echo "Usage: ./build.sh <docker image name> <docker image version>"
  echo
  echo "Example: ./build.sh myImage 1.0.0"
  exit 1
fi

CUSTOM_IMAGE="$1:$2"
CUSTOM_BASE_IMAGE=$1-base-image:$2

mvn clean package

./buildCustomBaseImage.sh "$CUSTOM_BASE_IMAGE"

./jlinkDockerBuild.sh "$CUSTOM_BASE_IMAGE" "$CUSTOM_IMAGE"

echo
echo "Built image $CUSTOM_IMAGE from customed jlink image $CUSTOM_BASE_IMAGE:"
echo
docker images | grep $1
