#!/bin/bash
set -e
if [ "$#" -eq 0 ]; then
    echo "Usage: printModuleSizes.sh <target image>"
    echo
    echo "Example: ./run.sh bellsoft/liberica-runtime-container:jdk-all-17-musl" 
    exit 1
fi

IMAGE=$1
MODULES=$2

echo "Check image $IMAGE module sizes"

mvn clean package

docker build --build-arg "IMAGE=$IMAGE" -f Dockerfile -t module-size:1.0.0 . --progress=plain

docker run -i -t module-size:1.0.0 java -jar app.jar
