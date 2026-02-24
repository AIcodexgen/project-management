# --- Stage 1: Install PHP Dependencies ---
FROM composer:2.5 AS composer-builder
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --ignore-platform-reqs

# --- Stage 2: Build Frontend Assets ---
FROM node:18-alpine AS asset-builder
WORKDIR /app
COPY --from=composer-builder /app/vendor ./vendor
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# --- Stage 3: Production PHP Environment ---
FROM richarvey/nginx-php-fpm:latest
WORKDIR /var/www/html

# Copy project files
COPY . .

# Copy built assets from Stage 2
COPY --from=asset-builder /app/public/build ./public/build

# Final PHP dependency install (with scripts and optimization)
RUN composer install --no-dev --optimize-autoloader

# Ensure permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Make the deploy script executable
RUN chmod +x render-deploy.sh

# Expose port 80
EXPOSE 80

# Use our custom script to start the container
CMD ["./render-deploy.sh"]
