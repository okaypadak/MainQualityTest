FROM maven:3.9.6-eclipse-temurin-17 as builder
WORKDIR /app
COPY . .

# 🔍 Debug log
RUN echo "📦 Maven kurulum başlıyor..." && \
    echo "📁 /app içeriği:" && ls -la /app && \
    echo "📁 /app/quality-auth-client:" && ls -la /app/quality-auth-client || true && \
    echo "📁 /app/quality-test:" && ls -la /app/quality-test || true

# 1. quality-auth-client kurulumu
RUN mvn install -DskipTests \
    -f /app/quality-auth-client/pom.xml \
    -Dmaven.multiModuleProjectDirectory=/app

# 2. quality-test derlemesi
RUN mvn package -DskipTests \
    -f /app/quality-test/pom.xml \
    -Dmaven.multiModuleProjectDirectory=/app

# 💥 Debug: target içeriğini kontrol et
RUN echo "🎯 quality-test/target içeriği:" && ls -la /app/quality-test/target || echo "❌ target dizini yok"

FROM eclipse-temurin:17
WORKDIR /app
COPY --from=builder /app/quality-test/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
