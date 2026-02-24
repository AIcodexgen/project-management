FROM richarvey/php-fpm-laravel:3.0.0

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Build time setup - ensuring everything is ready in the image
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run build && rm -rf node_modules

# Ensure permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port (Internal standard)
EXPOSE 80

# We let the richarvey image handle the startup, but we'll use 
# env vars in render.yaml to control its behavior.
