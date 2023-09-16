# Bellsoft Liberica + Spring + Maven example project
Example project for creating a custom [Bellsoft Liberica image](https://bell-sw.com/blog/creating-java-microcontainers-with-microprofile-jlink-and-liberica-jdk/) for a Spring Boot Maven project, with the help of `jdep` and `jlink`.

Run

```
./build.sh my-image 1.0.0
```

which produces two images, listed using `docker images | grep my-image`:

```
my-image              1.0.0     bc17624fca2e   Less than a second ago   93.6MB
my-image-base-image   1.0.0     1f11f65e1c8a   2 seconds ago            73MB
```

where the base image is comparable to the [liberica-openjdk-alpine-musl](https://hub.docker.com/r/bellsoft/liberica-openjdk-alpine-musl/tags) image size of about 72 MB (down from 160 MB in [liberica-runtime-container:jdk-all-17-musl](https://hub.docker.com/r/bellsoft/liberica-runtime-container/tags?page=1&name=jdk-all-17-musl)).

