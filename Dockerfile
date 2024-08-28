# Dockerfile
FROM python:3.12-slim

WORKDIR /cloud_run_app

# copy files into the container image #
COPY app.py app.py
COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

CMD exec gunicorn \
  --bind :$PORT \
  --workers 1 \
  --threads 8 \
  --timeout 0 \
  app:app
