#!/usr/bin/env bash
#!/usr/bin/env bash
set -e

# Функция для чтения параметров конфигурации
get_config() {
    jq --raw-output ".$1" /data/options.json
}

# Читаем параметры конфигурации
DB_HOST=$(get_config 'db_host')
DB_PORT=$(get_config 'db_port')
DB_NAME=$(get_config 'db_name')
DB_USER=$(get_config 'db_user')
DB_PASSWORD=$(get_config 'db_password')
CREATE_SUPERUSER=$(get_config 'create_superuser')
SUPERUSER_USERNAME=$(get_config 'superuser_username')
SUPERUSER_EMAIL=$(get_config 'superuser_email')
SUPERUSER_PASSWORD=$(get_config 'superuser_password')

# Экспортируем переменные окружения для Django
export DB_HOST DB_PORT DB_NAME DB_USER DB_PASSWORD

# Устанавливаем дополнительные переменные окружения
export PYTHONUNBUFFERED=1
export DJANGO_SETTINGS_MODULE=StaySharp.settings  # Замените на название вашего проекта

# Ждем, пока база данных станет доступной
echo "Проверяем доступность базы данных..."
until nc -z -v -w30 $DB_HOST $DB_PORT
do
  echo "Ожидание подключения к базе данных на $DB_HOST:$DB_PORT..."
  sleep 5
done
echo "База данных доступна!"

# Выполняем миграции с повышенной детализацией вывода
python manage.py migrate --noinput --verbosity 2

# Создаем суперпользователя, если указано в настройках
if [ "$CREATE_SUPERUSER" = "true" ]; then
    echo "Создаем суперпользователя..."
    echo "from django.contrib.auth import get_user_model; \
User = get_user_model(); \
User.objects.filter(username='$SUPERUSER_USERNAME').exists() or \
User.objects.create_superuser('$SUPERUSER_USERNAME', '$SUPERUSER_EMAIL', '$SUPERUSER_PASSWORD')" | python manage.py shell
fi

# Импортируем данные из initial_data.json при первом запуске
if [ ! -f /data/.data_loaded ]; then
    if [ -f /app/initial_data.json ]; then
        echo "Импортируем данные из initial_data.json..."
        python manage.py loaddata initial_data.json
    else
        echo "Файл initial_data.json не найден. Пропускаем импорт данных."
    fi
    touch /data/.data_loaded
fi

# Собираем статические файлы
python manage.py collectstatic --noinput

# Запускаем сервер Django
python manage.py runserver 0.0.0.0:8000

# Если используете gunicorn, замените на:
# gunicorn StaySharp.wsgi:application --bind 0.0.0.0:8000
