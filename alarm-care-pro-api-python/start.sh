#!/bin/bash

# Start script for Alarm Care Pro API

echo "Starting Alarm Care Pro API..."

# Check if PostgreSQL is running
if ! pg_isready -h localhost -p 5432 -U admin > /dev/null 2>&1; then
    echo "PostgreSQL is not running. Starting with Docker Compose..."
    docker-compose up -d postgres
    echo "Waiting for PostgreSQL to be ready..."
    sleep 10
fi

# Activate virtual environment
source venv/bin/activate

# Run migrations
echo "Running database migrations..."
alembic upgrade head

# Start the API
echo "Starting FastAPI server..."
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
