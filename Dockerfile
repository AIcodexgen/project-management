# --- Stage 1: Build Frontend Assets ---
FROM node:18-alpine AS asset-builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# --- Stage 2: Production PHP Environment ---
FROM richarvey/nginx-php-fpm:latest
WORKDIR /var/www/html

# Copy project files
COPY . .

# Copy built assets from Stage 1
# This ensures we have the compiled CSS/JS without needing Node.js in production
COPY --from=asset-builder /app/public/build ./public/build

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Ensure permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Make the deploy script executable
RUN chmod +x render-deploy.sh

# Expose port 80
EXPOSE 80

# Use our custom script to start the container
CMD ["./render-deploy.sh"]
