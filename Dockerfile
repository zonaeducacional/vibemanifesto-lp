FROM nginx:alpine

# Copy static files to Nginx's default public directory
COPY . /usr/share/nginx/html

# Remove default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Create a more robust configuration for Fly.io
RUN echo 'server {\n\
    listen 8080 default_server;\n\
    listen [::]:8080 default_server;\n\
    \n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    \n\
    server_name _;\n\
    \n\
    # Handle all locations\n\
    location / {\n\
        try_files $uri $uri/ /index.html =404;\n\
    }\n\
    \n\
    # Add custom headers\n\
    add_header X-Frame-Options "SAMEORIGIN" always;\n\
    add_header X-XSS-Protection "1; mode=block" always;\n\
    add_header X-Content-Type-Options "nosniff" always;\n\
}' > /etc/nginx/conf.d/default.conf

# Expose port 8080
EXPOSE 8080

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
