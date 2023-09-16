# jvm-module-size-calculator
Utility project for calculating the size of modules within a JVM distribution.

This calculator will help you determine how much your JVM distribution (i.e. docker image) can be reduced in size for a specific application.

# License
[European Union Public Licence v1.2](https://eupl.eu/).

# Usage

## Calculator
Build the Maven project, 

```
mvn clean package
```

then run 

```
java -jar target/calculator-0.0.x-SNAPSHOT.jar
``

to see the module size within the currently installed JVM.

Run

```
java -jar target/calculator-0.0.x-SNAPSHOT.jar <comma-seperated-modules>
```

i.e.

```
java -jar target/calculator-0.0.x-SNAPSHOT.jar java.base,java.compiler,java.desktop
```

to calculate the size of modules.

## Docker
List module sizes using the script

```
./printModuleSizes.sh  <docler-image> 
```

i.e.

```
./printModuleSizes.sh bellsoft/liberica-runtime-container:jdk-all-17-musl
```

or calculate specific module sizes using

```
./calculateModulesSize.sh <docler-image> <comma-seperated-modules>
```

i.e.

```
./calculateModulesSize.sh bellsoft/liberica-runtime-container:jdk-all-17-musl "java.base,java.compiler,java.desktop,java.instrument,java.management,java.naming,java.net.http,java.prefs,java.rmi,java.scripting,java.security.jgss,java.security.sasl,java.sql,java.xml.crypto,jdk.httpserver,jdk.jfr,jdk.unsupported,jdk.xml.dom"
```

# Example
The project includes a [fully working example](images/liberica) for Liberica docker images with bash scripts:

 * builds Spring Boot Maven project
 * extracts the relevant modules using `jdeps`
 * builds a custom base image using `jlink`
 * builds a custom image with the Maven artifact 




