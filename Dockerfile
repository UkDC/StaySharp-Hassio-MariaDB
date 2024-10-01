# Базовый образ с Python
FROM python:3.9-slim

# Устанавливаем pkg-config и необходимые зависимости для MariaDB/MySQL
RUN apt-get update && \
    apt-get install -y gcc libmariadb-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы проекта в контейнер
COPY . /app

# Устанавливаем зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Экспортируем переменные окружения для mysqlclient
# Эти переменные необходимы для правильной сборки
ENV MYSQLCLIENT_CFLAGS="$(mysql_config --cflags)"
ENV MYSQLCLIENT_LDFLAGS="$(mysql_config --libs)"

# Создаем static файлы
RUN python manage.py collectstatic --noinput

# Указываем переменную окружения для запуска Django
ENV DJANGO_SETTINGS_MODULE=StaySharp.settings

# Открываем порт для сервера
EXPOSE 8000

# Команда для запуска проекта
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
