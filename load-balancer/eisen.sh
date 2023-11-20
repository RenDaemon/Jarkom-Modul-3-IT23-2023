#!/bin/bash

# Set the nameserver IP address as a variable
nameserver_ip="192.168.122.1"
ip_dns="10.75.1.3"

# Update /etc/resolv.conf with the nameserver IP
echo -e "nameserver $ip_dns\nnameserver $nameserver_ip" > /etc/resolv.conf

apt-get update
apt-get install apache2-utils -y
apt-get install nginx -y
apt-get install lynx -y

service nginx start

# Nginx Configuration
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/lb_php

# Creating a directory for htpasswd file
mkdir -p /etc/nginx/rahasisakita

# Creating an htpasswd file and adding a user
htpasswd -b -c /etc/nginx/rahasisakita/htpasswd netics ajkit23

echo 'upstream worker {
    # least_conn;
    # ip_hash;
    # hash $request_uri consistent;
    server 10.75.3.1;
    server 10.75.3.2;
    server 10.75.3.3;
}

server {
    listen 80;
    server_name granz.channel.it23.com www.granz.channel.it23.com;

    root /var/www/html;

    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {

        allow 10.75.3.69;
        allow 10.75.3.70;
        allow 10.75.3.19;
        allow 10.75.4.167;
        allow 10.75.4.168;
        # allow [ur ip here];
        deny all;

        proxy_pass http://worker;

        # Adding basic authentication
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/rahasisakita/htpasswd;
    }

    location ~ /its {
        proxy_pass https://www.its.ac.id;
        proxy_set_header Host www.its.ac.id;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
} ' > /etc/nginx/sites-available/lb_php

ln -s /etc/nginx/sites-available/lb_php /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

service nginx restart