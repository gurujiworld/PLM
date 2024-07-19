#!/bin/bash

# Update package index
echo "Updating package index..."
sudo apt-get update

# Install Apache2
echo "Installing Apache2..."
sudo apt-get install -y apache2

# Ensure the Apache2 service is enabled and started
echo "Starting and enabling Apache2 service..."
sudo systemctl enable apache2
sudo systemctl start apache2

# Verify Apache2 is running
echo "Verifying Apache2 service status..."
sudo systemctl status apache2 --no-pager

# Basic firewall configuration (assuming UFW is being used)
echo "Configuring the firewall to allow HTTP and HTTPS traffic..."
sudo ufw allow 'Apache Full'

# Test Apache2 installation
echo "Testing Apache2 installation..."
if curl -sI http://localhost | grep "200 OK" > /dev/null; then
    echo "Apache2 is installed and running successfully."
else
    echo "Apache2 installation failed or is not running."
fi

# Optional: Create a simple HTML page
echo "Creating a basic HTML page..."
echo "<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Siemens PLM Application</title>
</head>
<body>
    <h1>Success! The PLM Web Tier servers are working!</h1>
    <p>Welcome to your new PLM web server!</p>
</body>
</html>" | sudo tee /var/www/html/index.html

echo "Apache2 installation and configuration completed."
