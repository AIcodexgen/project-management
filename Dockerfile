FROM richarvey/php-fpm-laravel:3.0.0

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Build time setup
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run build && rm -rf node_modules

# Ensure permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Make the deploy script executable
RUN chmod +x render-deploy.sh

# Expose port 80 (standard for this image)
EXPOSE 80

# Use our custom script to start the container
CMD ["./render-deploy.sh"]
