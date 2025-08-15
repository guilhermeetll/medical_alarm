#!/bin/bash

# Script to run Alembic migrations inside the Docker container

echo "Running Alembic migrations..."

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL..."
while ! pg_isready -h postgres -p 5432 -U admin; do
  sleep 1
done

echo "PostgreSQL is ready. Running migrations..."
alembic upgrade head

echo "Migrations completed."
