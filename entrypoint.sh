#!/bin/sh

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

#python manage.py flush --no-input
python pyas2_rh/manage.py collectstatic --no-input
python pyas2_rh/manage.py migrate
python pyas2_rh/manage.py runserver
#gunicorn pyas2_rh.pyas2_rh.wsgi:application --bind 0.0.0.0:8000


exec "$@"
