ARG IMAGE
FROM $IMAGE
ADD target/*.jar app.jar

CMD ["java", "-jar", "app.jar"]
