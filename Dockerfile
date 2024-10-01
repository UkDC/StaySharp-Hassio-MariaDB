# Базовый образ с Python
FROM python:3.9-slim

# Устанавливаем зависимости для Django и Home Assistant add-on
RUN apt-get update && \
    apt-get install -y gcc libpq-dev default-libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/*

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы проекта в контейнер
COPY . /app

# Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Устанавливаем библиотеку для работы с MariaDB
RUN pip install mysqlclient

# Создаем static файлы
RUN python manage.py collectstatic --noinput

# Указываем переменную окружения для запуска Django
ENV DJANGO_SETTINGS_MODULE=StaySharp.settings

# Открываем порт для сервера
EXPOSE 8000

# Команда для запуска проекта
CMD ["bash", "run.sh"]


