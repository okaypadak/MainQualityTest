FROM maven:3.9.6-eclipse-temurin-17 as builder
WORKDIR /app
COPY . .

# 1. Önce quality-auth-client’i local repo’ya kur
RUN mvn install -DskipTests \
    -f quality-auth-client/pom.xml \
    -Dmaven.multiModuleProjectDirectory=/app

# 2. Sonra quality-test’i derleyip target’e .jar çıkar
RUN mvn package -DskipTests \
    -f quality-test/pom.xml \
    -Dmaven.multiModuleProjectDirectory=/app

# Final çalışma imajı
FROM eclipse-temurin:17
WORKDIR /app
COPY --from=builder /app/quality-test/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
