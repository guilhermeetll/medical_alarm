#!/bin/bash

echo "Testing Docker Compose setup"

echo "1. Testing normal startup (without simulator)"
docker-compose up -d

echo "Waiting for services to start..."
sleep 30

echo "Checking running services:"
docker-compose ps

echo "2. Testing startup with simulator"
docker-compose --profile simulator up -d

echo "Waiting for simulator services to start..."
sleep 30

echo "Checking all running services:"
docker-compose --profile simulator ps

echo "3. Shutting down all services"
docker-compose --profile simulator down

echo "Test completed"
