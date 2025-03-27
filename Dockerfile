# Этап сборки
FROM eclipse-temurin:21 AS builder

# Зависимости для Gradle
RUN apt-get update && apt-get install -y curl findutils

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

COPY . .

# Копируем файлы Gradle
COPY gradlew .
COPY gradle .

# Копируем файлы проекта
COPY ui-template-service .

# Даем права на выполнение Gradle wrapper
RUN chmod +x gradlew

# Сборка проекта
RUN ./gradlew build -x test

# Используем официальный образ OpenJDK для запуска
FROM eclipse-temurin:21-ubi9-minimal

WORKDIR /app

# Копируем собранный JAR-файл из этапа сборки
COPY --from=builder /app/ui-template-service/build/libs/*.jar ui-template-service.jar

# Команда для запуска приложения
ENTRYPOINT ["java", "-jar", "ui-template-service.jar"]
