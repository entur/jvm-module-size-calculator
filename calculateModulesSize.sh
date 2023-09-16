#!/bin/bash
set -e
if [ "$#" -eq 0 ]; then
    echo "Script for calculating module sizes within a docker image"
    echo
    echo "Usage: calculateModuleSizes.sh <target image> <modules>"
    echo
    echo "Example: ./calculateModuleSizes.sh bellsoft/liberica-runtime-container:jdk-all-17-musl" "java.base,java.compiler,java.desktop,java.instrument,java.management,java.naming,java.net.http,java.prefs,java.rmi,java.scripting,java.security.jgss,java.security.sasl,java.sql,java.xml.crypto,jdk.httpserver,jdk.jfr,jdk.unsupported,jdk.xml.dom"
    exit 1
fi

IMAGE=$1
MODULES=$2

echo "Check image $IMAGE for modules $MODULES"

cd calculator
mvn clean package
cd ..

docker build --build-arg "IMAGE=$IMAGE" -f ModuleSizeDockerfile -t module-size:1.0.0 . --progress=plain

docker run -i -t module-size:1.0.0 java -jar app.jar "$MODULES"

