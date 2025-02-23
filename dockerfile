# Use an official lightweight Python image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Install Flask (lightweight web framework)
RUN pip install flask

# Copy the application file
COPY app.py /app/

# Expose port 80 for ALB
EXPOSE 80

# Run the Flask app
CMD ["python", "app.py"]
