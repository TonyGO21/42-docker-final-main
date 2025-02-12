# Используем официальный образ Go для сборки
FROM golang:1.22 as builder

# Устанавливаем рабочую директорию в контейнере
WORKDIR /app

# Копируем модули и зависимости
COPY go.mod go.sum ./
RUN go mod download

# Копируем исходный код
COPY . .

# Собираем исполняемый файл
RUN go build -o tracker .

# Используем минимальный образ для финального контейнера
FROM debian:bookworm-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем исполняемый файл из builder-образа
COPY --from=builder /app/tracker .

# Копируем базу данных
COPY tracker.db .

# Открываем порт, если потребуется доступ извне
EXPOSE 8080

# Запускаем приложение
CMD ["./tracker"]
