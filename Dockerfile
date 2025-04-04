# Step 1: Use a minimal base image for the init container
FROM alpine:latest

# Set the working directory inside the container
# WORKDIR /app

# Copy only the necessary application files to the container
COPY . /app/

