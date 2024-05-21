# Use the official Nginx image from Docker Hub
FROM nginx:latest

# Copy your HTML file to the Nginx HTML directory
COPY index.html /usr/share/nginx/html/index.html

# Copy your gif image to the Nginx HTML directory
COPY MY-FRIENDS.gif /usr/share/nginx/html/MY-FRIENDS.gif

# Expose port 80 to the outside world
EXPOSE 80
