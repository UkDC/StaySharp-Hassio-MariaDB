#!/usr/bin/env bash
set -e

# Функция для логирования
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Извлечение параметров из конфигурации аддона
export DB_USER=$(jq -r '.db_user // empty' /data/options.json)
export DB_PASSWORD=$(jq -r '.db_password // empty' /data/options.json)
export DB_NAME=$(jq -r '.db_name // empty' /data/options.json)
export DB_HOST=$(jq -r '.db_host // empty' /data/options.json)
export DB_PORT=$(jq -r '.db_port // empty' /data/options.json)
export ADMIN_USERNAME=$(jq -r '.admin_username // empty' /data/options.json)
export ADMIN_PASSWORD=$(jq -r '.admin_password // empty' /data/options.json)
export ADMIN_EMAIL=$(jq -r '.admin_email // empty' /data/options.json)

# Проверка наличия всех необходимых параметров
if [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ] || [ -z "$DB_NAME" ] || [ -z "$DB_HOST" ] || [ -z "$DB_PORT" ] ||
   [ -z "$ADMIN_USERNAME" ] || [ -z "$ADMIN_PASSWORD" ] || [ -z "$ADMIN_EMAIL" ]; then
    log "Ошибка: Не все необходимые параметры указаны в конфигурации аддона."
    exit 1
fi

# Ожидание доступности базы данных
log "Ожидание доступности базы данных..."
timeout=60
while ! mysqladmin ping -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" --silent; do
    sleep 1
    timeout=$((timeout - 1))
    if [ $timeout -eq 0 ]; then
        log "Ошибка: Не удалось подключиться к базе данных в течение 60 секунд."
        exit 1
    fi
done

# Создание базы данных, если она не существует
log "Создание базы данных $DB_NAME, если она не существует..."
mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

# Импорт данных из backup.sql, если он существует
if [ -f /app/backup.sql ]; then
    log "Импортируем данные из backup.sql в MariaDB..."
    mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < /app/backup.sql
else
    log "Архивный файл backup.sql не найден. Пропускаем импорт."
fi

# Применение миграций
log "Применяем миграции базы данных..."
python manage.py migrate

# Создание суперпользователя, если он не существует
log "Создание или обновление суперпользователя..."
python manage.py shell << END
from django.contrib.auth import get_user_model
User = get_user_model()
try:
    user = User.objects.get(username='${ADMIN_USERNAME}')
    user.set_password('${ADMIN_PASSWORD}')
    user.email = '${ADMIN_EMAIL}'
    user.is_superuser = True
    user.is_staff = True
    user.save()
    print("Суперпользователь обновлен.")
except User.DoesNotExist:
    User.objects.create_superuser('${ADMIN_USERNAME}', '${ADMIN_EMAIL}', '${ADMIN_PASSWORD}')
    print("Суперпользователь создан.")
END

# Сбор статических файлов
log "Сбор статических файлов..."
python manage.py collectstatic --noinput

# Запуск сервера
log "Запускаем сервер Django..."
python manage.py runserver 0.0.0.0:8000


