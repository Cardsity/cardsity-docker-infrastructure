#!/usr/bin/env sh

# Replace environment variables in the nginx configuration with environment variables
envsubst '$HOST_FRONTEND:$HOST_DECK_SERVER' < /app/nginx.conf.template > /etc/nginx/nginx.conf

# Run the server
nginx -g 'daemon off;'