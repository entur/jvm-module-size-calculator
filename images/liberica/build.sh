#!/bin/bash
set -e

if [ "$#" -eq 0 ]; then
  echo "Usage: ./build.sh <docker image name> <docker image version>"
  echo
  echo "Example: ./build.sh my-image 1.0.0"
  exit 1
fi

CUSTOM_IMAGE="$1:$2"
CUSTOM_BASE_IMAGE=$1-base-image:$2

mvn clean package

./customBaseImageDockerBuild.sh "$CUSTOM_BASE_IMAGE"

./customAppImageDockerBuild.sh "$CUSTOM_BASE_IMAGE" "$CUSTOM_IMAGE"

echo
echo "Built image $CUSTOM_IMAGE from customed jlink image $CUSTOM_BASE_IMAGE:"
echo
docker images | grep $1

echo
echo "Run the app using the command"
echo "docker run -i -t $CUSTOM_IMAGE"

