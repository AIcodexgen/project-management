FROM richarvey/nginx-php-fpm:latest

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

# Expose port 80
EXPOSE 80

# The richarvey image uses /start.sh by default
# We use our custom script which eventually calls /start.sh
CMD ["./render-deploy.sh"]
