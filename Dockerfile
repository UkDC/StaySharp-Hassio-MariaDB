FROM python:3.9-slim

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    libssl-dev \
    libffi-dev \
    python3-dev \
    jq \
    pkg-config \
    libmariadb-dev-compat \
    libmariadb-dev \
    mariadb-client \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*


# Устанавливаем зависимости Python
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Копируем код приложения
COPY . /app
WORKDIR /app

# Создаем директорию для конфигурации и данных
ENV CONFIG_PATH=/config
RUN mkdir -p $CONFIG_PATH

# Устанавливаем переменные окружения
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=StaySharp.settings
ENV IN_DOCKER=True

# Экспонируем порт
EXPOSE 8000

# Копируем скрипт запуска
COPY run.sh /
RUN chmod +x /run.sh

# Запускаем скрипт запуска
CMD ["/run.sh"]



## Базовый образ с Python
#FROM python:3.9-slim
#
## Устанавливаем зависимости для PostgreSQL (libpq-dev), MariaDB (libmariadb-dev) и pkg-config
#RUN apt-get update && \
#    apt-get install -y gcc libmariadb-dev libpq-dev pkg-config && \
#    rm -rf /var/lib/apt/lists/*
#
## Устанавливаем рабочую директорию
#WORKDIR /app
#
## Копируем файлы проекта в контейнер
#COPY . /app
#
## Устанавливаем зависимости
#RUN pip install --no-cache-dir -r requirements.txt
#
## Экспортируем переменные окружения для mysqlclient
#ENV MYSQLCLIENT_CFLAGS="$(mysql_config --cflags)"
#ENV MYSQLCLIENT_LDFLAGS="$(mysql_config --libs)"
#
## Создаем static файлы
#RUN python manage.py collectstatic --noinput
#
## Указываем переменную окружения для запуска Django
#ENV DJANGO_SETTINGS_MODULE=StaySharp.settings
#
## Открываем порт для сервера
#EXPOSE 8000
#
## Команда для запуска проекта
#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
