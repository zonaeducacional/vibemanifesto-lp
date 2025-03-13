FROM nginx:alpine

# Copy static files to Nginx's default public directory
COPY . /usr/share/nginx/html

# Configure Nginx for single page applications
RUN echo 'server {\n\
    listen 8080;\n\
    server_name localhost;\n\
    root /usr/share/nginx/html;\n\
    index index.html;\n\
    # Handle 404s by redirecting to index.html\n\
    location / {\n\
        try_files $uri $uri/ /index.html;\n\
    }\n\
}' > /etc/nginx/conf.d/default.conf

# Expose port 8080
EXPOSE 8080

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
