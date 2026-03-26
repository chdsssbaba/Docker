#!/bin/bash

echo "Updating system..."
sudo apt update -y

echo "Installing Docker..."
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

echo "Creating app folder..."
mkdir -p ~/app
cd ~/app

echo "Creating Flask app..."
cat > app.py <<EOF
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Hello from Docker 🚀"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

echo "Creating requirements.txt..."
echo "flask" > requirements.txt

echo "Creating Dockerfile..."
cat > Dockerfile <<EOF
FROM python:3.10
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
EOF

echo "Building Docker image..."
sudo docker build -t myapp .

echo "Creating volume folder..."
mkdir -p ~/data
echo "Hello from host volume" > ~/data/test.txt

echo "Running container..."
sudo docker run -d -p 5000:5000 -v ~/data:/data --name mycontainer myapp

echo "✅ DONE! Open in browser: http://<your-public-ip>:5000"
