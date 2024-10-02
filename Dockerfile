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
    netcat-openbsd \
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
