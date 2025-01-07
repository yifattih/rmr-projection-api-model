# app/Dockerfile
FROM python:3.11-slim

# Install updates
RUN apt-get autoremove \
    && groupadd -f -r yifattih \
    && useradd -r -g yifattih -m -d /home/yifattih -s /bin/bash yifattih

# Create a group and user (with error handling if already exists)
# RUN groupadd -f -r yifattih \
#     && useradd -r -g yifattih -m -d /home/yifattih -s /bin/bash yifattih

# Set the working directory for the app
WORKDIR /api

# Set ownership permissions to working directory
RUN chown -R yifattih:yifattih /api

# Change user
USER yifattih 

# Copy app-specific requirements
COPY requirements.txt /api/

# Update pip and and install requirements
RUN  pip install --user --upgrade pip \
    && pip install --user --no-cache-dir -r requirements.txt

# Add the user's local bin directory to PATH
ENV PATH="/home/yifattih/.local/bin:$PATH"

# Copy the app code into the container
COPY src/ /api/src/

EXPOSE 8000

# Copy the app code into the container
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "3"]