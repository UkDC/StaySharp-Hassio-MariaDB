# Базовый образ с Python
FROM python:3.9-slim

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем только файл requirements.txt
COPY requirements.txt .

# Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Копируем остальные файлы проекта
COPY . .

# Создаем static файлы
RUN python manage.py collectstatic --noinput

# Указываем переменную окружения для запуска Django
ENV DJANGO_SETTINGS_MODULE=StaySharp.settings

# Открываем порт для сервера
EXPOSE 8000

# Команда для запуска проекта
CMD ["bash", "run.sh"]