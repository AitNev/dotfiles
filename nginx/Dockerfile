# Use the official Nginx image as the base image
FROM nginx:latest

# Update the package lists and install Certbot and its Nginx plugin
RUN apt-get update && apt-get install -y certbot python3-certbot-nginx

# Clean up APT cache to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose ports for HTTP and HTTPS
EXPOSE 80
EXPOSE 443

# Entrypoint command to start Nginx
CMD ["nginx", "-g", "daemon off;"]
