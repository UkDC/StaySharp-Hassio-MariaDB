
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

# Копируем файлы проекта в контейнер
COPY . /app

# Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Создаем static файлы
RUN python manage.py collectstatic --noinput

# Указываем переменную окружения для запуска Django
ENV DJANGO_SETTINGS_MODULE=StaySharp.settings

# Открываем порт для сервера
EXPOSE 8000

# Команда для запуска проекта
CMD ["bash", "run.sh"]



