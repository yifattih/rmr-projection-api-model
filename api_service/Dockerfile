# app/Dockerfile
FROM python:3.11-slim

# Install updates
RUN apt-get update && apt-get upgrade -y && apt-get install -y

# Set the working directory for the app
WORKDIR /api_service

# Update pip
RUN pip install --upgrade pip

# Copy app-specific requirements and install them
COPY requirements.txt /api_service/
RUN pip install --no-cache-dir -r requirements.txt


# Copy the app code into the container
COPY src/ /api_service/src/

# Copy the app code into the container
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]