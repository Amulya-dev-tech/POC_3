# ---- Build stage ----
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -q -DskipTests clean package
 
# ---- Runtime stage ----
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# copy the shaded jar (usually ends with -shaded.jar)
COPY --from=build /app/target/*-shaded.jar app.jar
ENTRYPOINT ["java","-jar","app.jar"]
