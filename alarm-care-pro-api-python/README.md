# Alarm Care Pro API - JWT Authentication

A FastAPI-based REST API with JWT authentication for the Alarm Care Pro application.

## Features

- JWT-based authentication
- User registration and login
- User management (CRUD operations)
- PostgreSQL database with SQLAlchemy ORM
- Alembic migrations
- Password hashing with bcrypt
- CORS support

## Requirements

- Python 3.8+
- PostgreSQL 16+
- Docker and Docker Compose (for database)

## Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd alarm-care-pro-api-python
   ```

2. **Create virtual environment**

   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**

   ```bash
   pip install -r requirements.txt
   ```

4. **Set up environment variables**
   Copy `.env` file and modify as needed:

   ```bash
   cp .env.example .env
   ```

5. **Start PostgreSQL with Docker Compose**

   ```bash
   docker-compose up -d postgres
   ```

6. **Run database migrations**

   ```bash
   alembic upgrade head
   ```

7. **Start the application**
   ```bash
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

## API Documentation

Once the application is running, you can access:

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## API Endpoints

### Authentication

- `POST /auth/register` - Register a new user
- `POST /auth/token` - Login and get JWT token
- `GET /auth/me` - Get current user info
- `POST /auth/logout` - Logout (token invalidation handled client-side)

### Users

- `GET /users/` - List all users (requires authentication)
- `POST /users/` - Create a new user (requires superuser)
- `GET /users/{user_id}` - Get user by ID
- `PUT /users/{user_id}` - Update user
- `DELETE /users/{user_id}` - Delete user

## Usage Examples

### Register a new user

```bash
curl -X POST "http://localhost:8000/auth/register" \
     -H "Content-Type: application/json" \
     -d '{
       "email": "user@example.com",
       "username": "johndoe",
       "password": "securepassword123",
       "full_name": "John Doe"
     }'
```

### Login

```bash
curl -X POST "http://localhost:8000/auth/token" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "username=johndoe&password=securepassword123"
```

### Access protected endpoint

```bash
curl -X GET "http://localhost:8000/auth/me" \
     -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Database Migrations

### Create a new migration

```bash
alembic revision --autogenerate -m "Description of changes"
```

### Apply migrations

```bash
alembic upgrade head
```

### Downgrade migrations

```bash
alembic downgrade -1
```

### Show migration history

```bash
alembic history
```

## Environment Variables

| Variable                    | Description                  | Default                                           |
| --------------------------- | ---------------------------- | ------------------------------------------------- |
| DATABASE_URL                | PostgreSQL connection string | postgresql://admin:admin@localhost:5432/alarm_app |
| SECRET_KEY                  | JWT secret key               | your-secret-key-change-this-in-production         |
| ALGORITHM                   | JWT algorithm                | HS256                                             |
| ACCESS_TOKEN_EXPIRE_MINUTES | Token expiration time        | 30                                                |
| DEBUG                       | Debug mode                   | True                                              |
| HOST                        | Server host                  | 0.0.0.0                                           |
| PORT                        | Server port                  | 8000                                              |

## Development

### Running tests

```bash
pytest
```

### Code formatting

```bash
black app/
```

### Type checking

```bash
mypy app/
```

## Security Notes

- Change the default `SECRET_KEY` in production
- Use HTTPS in production
- Consider implementing refresh tokens for better security
- Implement rate limiting for authentication endpoints
- Use environment variables for sensitive configuration

## Docker Support

To run with Docker:

```bash
# Build the image
docker build -t alarm-care-pro-api .

# Run the container
docker run -p 8000:8000 --env-file .env alarm-care-pro-api
```
