#!/bin/bash
set -e

if [ "$#" -eq 0 ]; then
  echo "Usage: ./customBaseImageDockerBuild.sh <Expected docker image tag argument>"
  echo
  echo "Example: ./customBaseImageDockerBuild.sh myCustomBaseImage:1.0.0"
  exit 1
fi

CUSTOM_BASE_IMAGE=$1

if [ -d "./target/app" ] 
then
     rm -rf ./target/app
fi

JAR=$(find ./target/* -maxdepth 1 -name '*.jar')

mkdir --parents target/app

unzip "${JAR}" -d target/app

MODULES=$(jdeps --print-module-deps --ignore-missing-deps --recursive --multi-release 17 --class-path="./target/app/BOOT-INF/lib/*" --module-path="./target/app/BOOT-INF/lib/*" ${JAR})

NC='\033[0m'
GREEN='\033[0;97m'

echo
echo -e "Modules are ${GREEN}${MODULES}${NC}"
echo

docker build --build-arg MODULES=${MODULES} -f customBaseImageDockerfile -t "$CUSTOM_BASE_IMAGE" . --progress=plain

echo "Built base image $CUSTOM_BASE_IMAGE"
