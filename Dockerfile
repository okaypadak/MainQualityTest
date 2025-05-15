# 1. Maven build aşaması - Java 17 ile
FROM maven:3.9.6-eclipse-temurin-17 as builder
WORKDIR /app
COPY . .
RUN mvn clean install -DskipTests

# 2. Uygulama çalıştırma aşaması - Java 17 ile
FROM eclipse-temurin:17
WORKDIR /app
COPY --from=builder /app/quality-test/target/quality-test-1.0.jar app.jar
EXPOSE 8082
ENTRYPOINT ["java", "-jar", "app.jar"]
