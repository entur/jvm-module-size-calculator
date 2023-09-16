#!/bin/bash
set -e
if [ "$#" -eq 0 ]; then
    echo "Script for printing module sizes within a docker image"
    echo
    echo "Usage: printModuleSizes.sh <target image>"
    echo
    echo "Example: ./printModuleSizes.sh bellsoft/liberica-runtime-container:jdk-all-17-musl" 
    exit 1
fi

IMAGE=$1
MODULES=$2

echo "Check image $IMAGE module sizes"

cd calculator
mvn clean package
cd ..

docker build --build-arg "IMAGE=$IMAGE" -f ModuleSizeDockerfile -t module-size:1.0.0 . --progress=plain

docker run -i -t module-size:1.0.0 java -jar app.jar

