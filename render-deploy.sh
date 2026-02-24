#!/usr/bin/env bash

# Run migrations non-interactively
echo "Running migrations..."
php artisan migrate --force

# Start the web server (Nginx + PHP-FPM)
# The richarvey image uses a /start.sh script internally
echo "Starting web server..."
/start.sh
