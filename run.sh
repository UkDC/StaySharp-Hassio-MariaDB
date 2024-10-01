#!/usr/bin/env bash
set -e

# Функция для проверки доступности базы данных
wait_for_db() {
    echo "Waiting for database..."
    while ! mysqladmin ping -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" --silent; do
        sleep 1
    done
    echo "Database is available"
}

# Экспорт переменных окружения
export DB_USER=$(jq -r '.db_user // empty' /data/options.json)
export DB_PASSWORD=$(jq -r '.db_password // empty' /data/options.json)
export DB_NAME=$(jq -r '.db_name // empty' /data/options.json)
export DB_HOST=$(jq -r '.db_host // empty' /data/options.json)
export DB_PORT=$(jq -r '.db_port // empty' /data/options.json)

# Ожидание доступности базы данных
wait_for_db

# Применение миграций
echo "Applying database migrations..."
python manage.py migrate

# Запуск сервера
# Изменено: запуск через runserver для разработки
echo "Starting Django server with runserver..."
python manage.py runserver 0.0.0.0:8000