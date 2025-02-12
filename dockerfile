# Use an official lightweight Python image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Print "Hello, World!" when the container runs
CMD ["echo", "Hello, World!"]
