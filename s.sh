#!/bin/bash

# Update system
sudo apt update

# Install Docker
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

# Create app folder
mkdir app
cd app

# Create Flask app
cat <<EOF > app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Hello from Docker 🚀"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# Requirements file
echo "flask" > requirements.txt

# Dockerfile
cat <<EOF > Dockerfile
FROM python:3.10
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
EOF

# Build Docker image
sudo docker build -t myapp .

# Create volume folder
mkdir ~/data
echo "Hello from host volume" > ~/data/test.txt

# Run container
sudo docker run -d -p 5000:5000 -v ~/data:/data --name mycontainer myapp

echo "✅ DONE! Open in browser: http://<your-public-ip>:5000"