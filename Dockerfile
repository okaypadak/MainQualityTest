FROM maven:3.9.6-eclipse-temurin-17 as builder
WORKDIR /app
COPY . .

RUN mvn install -DskipTests -f /quality-auth-client/pom.xml

FROM eclipse-temurin:17
WORKDIR /app
COPY --from=builder /app/quality-auth-client/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
