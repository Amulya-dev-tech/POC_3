FROM openjdk:java-17-amazon-corretto
WORKDIR /app
COPY target/java-sample-app-1.0.jar app.jar
CMD ["java", "-jar", "app.jar"]
 
