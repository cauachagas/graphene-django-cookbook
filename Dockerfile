FROM python:3.8.9-alpine

RUN apk add --no-cache bash

ENV PYTHONDONTWRITEBYTECODE 1

ENV PYTHONUNBUFFERED 1

WORKDIR /code

COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

COPY cookbook .

COPY manage.py .