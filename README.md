# jvm-module-size-calculator
Project for calculating the size of modules within a JVM distribution.

This will help you determine whether how much your JVM distribution can be reduced in size for a specific application.

Obtain relevant modules with the help of `jdep`.

# License
[European Union Public Licence v1.2](https://eupl.eu/).

# Usage
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



