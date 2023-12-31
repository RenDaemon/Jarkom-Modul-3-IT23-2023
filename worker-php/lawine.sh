# Set the nameserver IP address as a variable
nameserver_ip="192.168.122.1"
ip_dns="10.75.1.3"

# Update /etc/resolv.conf with the nameserver IP
echo -e "nameserver $ip_dns\nnameserver $nameserver_ip" > /etc/resolv.conf

#Utils Installation
apt-get update
apt-get install nginx -y
apt-get install wget -y
apt-get install unzip -y
apt-get install lynx -y
apt-get install htop -y
apt-get install apache2-utils -y
apt-get install php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp php7.3-curl php7.3-intl php7.3-mbstring php7.3-xmlrpc php7.3-gd php7.3-xml php7.3-cli php7.3-zip -y

service nginx start
service php7.3-fpm start

#Attachments
wget -O '/var/www/granz.channel.it23.com' 'https://drive.google.com/u/0/uc?id=1ViSkRq7SmwZgdK64eRbr5Fm1EGCTPrU1&export=download'
unzip -o /var/www/granz.channel.it23.com -d /var/www/
rm /var/www/granz.channel.it23.com
mv /var/www/modul-3 /var/www/granz.channel.it23.com

#Nginx Config
cp /etc/nginx/sites-available/default /etc/nginx/sites-available/granz.channel.it23.com
ln -s /etc/nginx/sites-available/granz.channel.it23.com /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

echo 'server {
    listen 80;
    server_name _;

    root /var/www/granz.channel.it23.com;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.3-fpm.sock;  # Sesuaikan versi PHP dan socket
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}' > /etc/nginx/sites-available/granz.channel.it23.com

service nginx restart