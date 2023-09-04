#!/bin/bash

echo -e "\033[0;32mDeploying updates to Nginx...\033[0m"

# Build the project.
hugo -t hugo-blog-awesome

# Go To Public folder
cd public

## Copy files to Nginx folder
cp -R * /var/www/html/

## Restart Nginx
systemctl reload nginx

