#!/usr/bin/env bash

# Экспортируем переменные окружения из конфигурации аддона
export DB_USER=$(jq -r '.db_user' /data/options.json)
export DB_PASSWORD=$(jq -r '.db_password' /data/options.json)
export DB_NAME=$(jq -r '.db_name' /data/options.json)
export DB_HOST=$(jq -r '.db_host' /data/options.json)
export DB_PORT=$(jq -r '.db_port' /data/options.json)

# Импорт данных из backup.sql, если он существует
if [ -f /app/backup.sql ]; then
    echo "Импортируем данные из backup.sql в MariaDB..."
    mysql -u "$DB_USER" -p"$DB_PASSWORD" -h "$DB_HOST" "$DB_NAME" < /app/backup.sql
else
    echo "Архивный файл backup.sql не найден. Пропускаем импорт."
fi

# Применение миграций
echo "Применяем миграции базы данных..."
python manage.py migrate

# Запуск сервера
echo "Запускаем сервер Django..."
python manage.py runserver 0.0.0.0:8000


