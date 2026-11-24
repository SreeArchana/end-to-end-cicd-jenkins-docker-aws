
# Use Python base image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy dependency file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY app/ ./app/

# Expose Flask port
EXPOSE 5000

# Start Flask application
CMD ["python", "app/app.py"]
