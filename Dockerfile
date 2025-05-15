FROM maven:3.9.6-eclipse-temurin-17 as builder
WORKDIR /app
COPY . .

RUN git clone https://github.com/okaypadak/quality-auth-client.git && \
    git clone https://github.com/okaypadak/quality-test.git

# 🔍 Debug log
RUN echo "📦 Maven kurulum başlıyor..." && \
    echo "📁 /app içeriği:" && ls -la /app && \
    echo "📁 quality-auth-client:" && ls -la quality-auth-client || true && \
    echo "📁 quality-test:" && ls -la quality-test || true

# 1. quality-auth-client kurulumu
RUN mvn install -DskipTests \
    -f quality-auth-client/pom.xml \
    -Dmaven.multiModuleProjectDirectory=/app

# 2. quality-test derlemesi
RUN mvn package -DskipTests \
    -f quality-test/pom.xml \
    -Dmaven.multiModuleProjectDirectory=/app

# 💥 Debug: target içeriğini kontrol et
RUN echo "🎯 quality-test/target içeriği:" && ls -la /app/quality-test/target || echo "❌ target dizini yok"

FROM eclipse-temurin:17
WORKDIR /app
COPY --from=builder /app/quality-test/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
