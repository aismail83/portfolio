# Use the official Python slim image for reduced size
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory
WORKDIR /myportfollio

# Install system dependencies
RUN apt-get update && apt-get install zstd && yum install zstd && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --upgrade mise
RUN mise use -g python@3.12

# Copy project files
COPY . .

# Expose the port Fly.io expects the app to bind to
EXPOSE 8080

# Collect static files during the build
RUN python manage.py collectstatic --noinput

# Run Gunicorn to serve the application
CMD ["gunicorn", "myproject.wsgi:application", "--bind", "0.0.0.0:8080", "--workers", "3"]
