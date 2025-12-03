FROM openjdk:openjdk:17-alpine
WORKDIR /app
COPY target/java-sample-app-1.0.jar app.jar
CMD ["java", "-jar", "app.jar"]
 
