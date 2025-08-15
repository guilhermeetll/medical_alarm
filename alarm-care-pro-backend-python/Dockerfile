FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 4444
EXPOSE 22001
EXPOSE 22002
EXPOSE 22003
EXPOSE 23000
EXPOSE 2222

CMD ["python", "server.py"]
