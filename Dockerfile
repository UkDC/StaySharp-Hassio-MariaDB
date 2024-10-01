# Базовый образ с Python
FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt --verbose

COPY . .

# Создаем директорию для статических файлов
RUN mkdir -p /app/staticfiles

# Собираем статические файлы
RUN python manage.py collectstatic --noinput

ENV DJANGO_SETTINGS_MODULE=StaySharp.settings

EXPOSE 8000

CMD ["bash", "run.sh"]