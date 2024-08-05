# Create the base image
ARG PYTHON_VERSION

## Base image contains the build environment and developments dependencies and no application code. It can be used for development.
FROM python:${PYTHON_VERSION}-alpine AS base

# Update the system and install needed packages
#        zlib zlib-dev jpeg-dev freetype freetype-dev && \
RUN apk update && apk upgrade && \
    apk add git bash build-base gcc g++ make libffi-dev openssl-dev \
        zlib-dev jpeg-dev freetype-dev && \
    apk add --no-cache --virtual .build-deps python3-dev && \
    apk add --no-cache --update python3

## DJANGO: Create the APP Image
FROM base AS django

# Create app directory
RUN mkdir /app
WORKDIR /app

# Bypassing an error while installing drf-yasg (Swagger package)
RUN pip install --upgrade pip setuptools

# Install Poetry
RUN pip install poetry

# Copy the poetry files
COPY ./pyproject.toml /app

# Install Dependencies
RUN poetry install

# Copy system files
COPY ./.version /app

FROM django AS with_mysql

# Install mysqlclient
RUN apk add --no-cache mariadb-connector-c-dev
RUN pip install mysqlclient

## DEV is used in development environment
FROM django AS dev

# Open port
EXPOSE 8000

# Run the dev server
CMD poetry run python manage.py runserver 0.0.0.0:8000

## Final contains the frontend application served by nginx
FROM with_mysql AS final
ARG ENV_RUN

# Copy system files
COPY ../.env /app

# Copy code to the image
COPY . /app/

# Collect static files
WORKDIR /app
# RUN poetry run python manage.py collectstatic --noinput

# Open port
EXPOSE 8000

# Run the server
RUN poetry add gunicorn
CMD poetry run gunicorn -c gunicorn.py "poc.wsgi:application"
