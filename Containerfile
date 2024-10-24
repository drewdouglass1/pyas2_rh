FROM python:3.11.10-alpine3.20

ADD requirements.txt /apps/

RUN set -ex \
    && apk update \
    && apk add --no-cache --virtual .build-deps build-base \
    && pip install --upgrade pip \
    && pip install --no-cache-dir -r /apps/requirements.txt \
    && apk add --virtual rundeps openssl-dev gcc postgresql-dev libffi-dev musl-dev \
    && apk del .build-deps \
    && mkdir -p /apps/staticfiles

WORKDIR /apps
COPY . /apps/

#Prevents Python from writing .pyc files to disk, which can save space and reduce I/O operations.
ENV PYTHONDONTWRITEBYTECODE=1

#Ensures that the Python output is sent straight to the terminal (or log) without being buffered, which is useful for debugging and real-time logging
ENV PYTHONUNBUFFERED=1

RUN chown -R 1001:0 /apps/ \
    && chmod -R g=u /apps
USER 1001
ENTRYPOINT ["/bin/sh", "/apps/entrypoint.sh"]

#CMD ["/usr/local/bin/python", "/apps/manage.py", "runserver", "0.0.0.0:8000"]
#CMD ["gunicorn", "pyas2_ocp.wsgi:application", "--bind", "0.0.0.0:8000"]

EXPOSE 8000