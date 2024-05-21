#!/bin/bash

# Function to handle errors
handle_error() {
  echo "Error on line $1"
  exit 1
}

# Trap errors
trap 'handle_error $LINENO' ERR

# Prompt for ngrok auth token using Python
python3 prompt_ngrok_auth.py

# Read the auth token from the file
if [ ! -f ngrok_auth_token.txt ]; then
  echo "ngrok auth token file not found!"
  exit 1
fi
NGROK_AUTH_TOKEN=$(cat ngrok_auth_token.txt)

# Download and install ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar -xvf ngrok-v3-stable-linux-amd64.tgz
sudo mv ngrok /usr/local/bin/

# Authenticate ngrok
ngrok authtoken "$NGROK_AUTH_TOKEN"

# Install code-server
curl -fsSL https://code-server.dev/install.sh | sh

# Install nano (optional)
sudo apt update
sudo apt install -y nano

# Start ngrok
ngrok http 6070 &
NGROK_PID=$!

# Wait for ngrok to start
sleep 5

# Start code-server
code-server --port 6070 &
CODE_SERVER_PID=$!

# Wait for code-server to start
sleep 4

# Display code-server configuration
cat ~/.config/code-server/config.yaml

# Wait for background processes to complete
wait $NGROK_PID
wait $CODE_SERVER_PID

# Cleanup
rm ngrok_auth_token.txt
