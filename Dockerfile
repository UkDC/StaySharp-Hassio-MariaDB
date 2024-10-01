
FROM python:3.9-slim

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y default-libmysqlclient-dev build-essential && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install mysqlclient && \
    python manage.py collectstatic --noinput

ENV DJANGO_SETTINGS_MODULE=StaySharp.settings

EXPOSE 8000

CMD ["bash", "run.sh"]



