#!/usr/bin/env bash
# Exit on error
set -o errexit

echo "Running composer..."
composer install --no-dev --optimize-autoloader

echo "Running npm..."
npm install
npm run build

echo "Caching config..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "Running migrations..."
# Force migrations in production
php artisan migrate --force
