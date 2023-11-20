# Jarkom-Modul-3-IT23-2023
**Praktikum Jaringan Komputer Modul 3**

## Author
| Nama | NRP |
|---------------------------|------------|
|Rendy Anfi Yudha| 5027211006 |
|Dhea Arfryza Ananda P. | 5027211013 |

# Laporan Resmi
## Daftar Isi
- [Soal 1](#soal-1)
- [Soal 2](#soal-2)
- [Soal 3](#soal-3)
- [Soal 4](#soal-4)
- [Soal 5](#soal-5)
- [Soal 6](#soal-6)
- [Soal 7](#soal-7)
- [Soal 8](#soal-8)
- [Soal 9](#soal-9)
- [Soal 10](#soal-10)
- [Soal 11](#soal-11)
- [Soal 12](#soal-12)
- [Soal 13](#soal-13)
- [Soal 14](#soal-14)
- [Soal 15](#soal-15)
- [Soal 16](#soal-16)
- [Soal 17](#soal-17)
- [Soal 18](#soal-18)
- [Soal 19](#soal-19)
- [Soal 20](#soal-20)


### Soal 13
#### Description :
Semua data yang diperlukan, diatur pada Denken dan harus dapat diakses oleh Frieren, Flamme, dan Fern.

#### PoC :
Karena perlu mengatur config pada Denken, berikut untuk konfigurasi yang diperlukan:

#### Installing
```bash
apt-get update
apt-get install mariadb-server -y
service mysql start
```
#### Denken
```bash
mysql <<EOF
CREATE USER 'kelompokit23'@'%' IDENTIFIED BY 'passwordit23';
CREATE USER 'kelompokit23'@'localhost' IDENTIFIED BY 'passwordit23';
CREATE DATABASE dbkelompokit23;
GRANT ALL PRIVILEGES ON *.* TO 'kelompokit23'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'kelompokit23'@'localhost';
FLUSH PRIVILEGES;
quit
EOF

# Log in to MySQL with the specified user and password
mysql -u kelompokit23 -p'passwordit23' <<EOF
SHOW DATABASES;
quit
EOF
```

Pada /etc/mysql/my.cnf :
```bash
echo '
[client-server]

# Import all .cnf files from configuration directory
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/

[mysqld]
skip-networking=0
skip-bind-address' > /etc/mysql/my.cnf

service mysql restart
```

## Output :
![Cuplikan layar 2023-11-20 114536](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/34b22820-e8ed-41c0-b448-23080e601b43)

Lalu melakukan konfigurasi pada 3 Worker Laravel
#### FFF
```bash
apt-get update
apt install lynx -y
apt-get install mariadb-client -y
```

Jalankan ```mariadb --host=10.75.2.2 --port=3306 --user=kelompokit23 --password```
![Cuplikan layar 2023-11-20 115151](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/43a09af7-6498-43f9-84c2-450b149df197)


### Soal 14
#### Description :
Frieren, Flamme, dan Fern memiliki Riegel Channel sesuai dengan quest guide berikut. Jangan lupa melakukan instalasi PHP8.0 dan Compose

#### PoC :
Karena perlu melakukan instalasi, perlu menambahkan beberapa konfigurasi dan instalasi pada 3 Laravel Worker

#### Frieren
```bash
apt-get update
apt install -y lsb-release apt-transport-https ca-certificates wget

# Add Sury.org repository key
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

# Add Sury.org repository to sources.list
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/$
# Update apt cache again
apt-get update

# Install PHP 7.3 and required extensions
apt install -y php8.0 php8.0-mbstring php8.0-xml php8.0-cli php8.0-common php$
apt-get install nginx -y

wget https://getcomposer.org/download/2.0.13/composer.phar
chmod +x composer.phar
mv composer.phar /usr/bin/composer

apt-get install git -y

cd /var/www
git clone https://github.com/martuafernando/laravel-praktikum-jarkom.git
cd /var/www/laravel-praktikum-jarkom
cp .env.example .env

```
Masuk ke dalam .env
```nano .env``` Ganti dibagian config tertentu menjadi:
```bash
DB_CONNECTION=mysql
DB_HOST=10.75.2.2
DB_PORT=3306
DB_DATABASE=dbkelompokit23
DB_USERNAME=kelompokit23
DB_PASSWORD=passwordit23
```

Run ```composer update```
Setelah composer berhasil di install, run php artisan:
```
php artisan migrate:fresh
php artisan db:seed --class=AiringsTableSeeder
php artisan key:generate
php artisan config:cache
php artisan migrate
php artisan db:seed
php artisan storage:link
php artisan jwt:secret
php artisan config:clear
```
```chown -R www-data.www-data /var/www/laravel-praktikum-jarkom/storage```

Lalu melakukan konfigurasi nginx pada ```nano /etc/nginx/sites-available/deploy```

```
server {

    listen 8001;

    root /var/www/laravel-praktikum-jarkom/public;

    index index.php index.html index.htm;
    server_name _;

    location / {
            try_files $uri $uri/ /index.php?$query_string;
    }

    # pass PHP scripts to FastCGI server
    location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
    }

location ~ /\.ht {
            deny all;
    }

    error_log /var/log/nginx/deploy_error.log;
    access_log /var/log/nginx/deploy_access.log;
}

```
Pada ```listen 8001``` diisi sesuai port di tiap worker.

Selanjutnya melakukan testing melalui ```lynx localhost:port```

Melakukan hal yang sama dengan ke-worker
```
10.75.4.1:8001 ; Frieren
10.75.4.2:8002 ; Flamme
10.75.4.1:8003 ; Fern
```

```lynx localhost:8001```

![Picture1](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/923f672d-f9a1-4d9e-b3ee-1a159ea3520a)

### Soal 15
#### Description :
Riegel Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second.  

#### PoC :
a. POST /auth/register

Masukkan config ke ```nano register.json```
```
{
  "username": "kelompokit23",
  "password": "passwordit23"
}
```

Lalu, run ```ab -n 100 -c 10 -p register.json -T application/json http://10.75.4.1:8001/api/auth/register``` pada Client

## Output :

![Picture2](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/9c7a8e10-0fa0-45ec-925b-64f18e7a756c)

### Soal 16
#### Description :
Riegel Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second.  

#### PoC :
b. POST /auth/login

Masukkan config ke ```nano login.json```
```
{
  "username": "kelompokit23",
  "password": "passwordit23"
}
```

Lalu, run ```ab -n 100 -c 10 -p login.json -T application/json http://10.75.4.1:8001/api/auth/login``` pada Client

## Output:

![Picture3](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/3f1bba3a-80ed-4460-8cdd-1e49c20a6006)

### Soal 17
#### Description :
Riegel Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second.  

#### PoC :
c. GET /me
Pada Client, jalankan command

```
curl -X POST -H "Content-Type: application/json" -d @login.json http://10.75.4.1:8001/api/auth/login > login_output.txt

token=$(cat login_output.txt | jq -r '.token')/me

ab -n 100 -c 10 -H "Authorization: Bearer $token" http://10.75.4.1:8001/api/me
```

Output:

![Picture4](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/1d0e2708-3a47-46b1-8598-d4213ff1267c)

### Soal 18
#### Description :
Untuk memastikan ketiganya bekerja sama secara adil untuk mengatur Riegel Channel maka **implementasikan Proxy Bind pada Eisen** untuk mengaitkan IP dari Frieren, Flamme, dan Fern

#### PoC :
Karena memerlukan implementasi Proxy Bind pada Eisen, maka lakukan config pada ```nano /etc/nginx/sites-available/worker-fff```
```bash
upstream worker {
    server 10.75.4.1:8001;
    server 10.75.4.2:8002;
    server 10.75.4.3:8003;
}

server {
    listen 80;
    server_name riegel.canyon.it23.com;

    location / {
        proxy_pass http://worker;
    }
}
```

Lalu, pada **Heiter** Ganti IP di Bind sebelumnya menjadi IP EISEN
```bash
echo ";
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     riegel.canyon.it23.com. root.riegel.canyon.it23.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@           IN      NS      riegel.canyon.it23.com.
@           IN      A       10.75.2.3 ; IP EISEN
www         IN      CNAME   riegel.canyon.it23.com.
" >/etc/bind/zones/riegel.canyon.it23.com
```

Pada Client **Revolte**
Jalankan command

```ab -n 100 -c 10 -p login.json -T application/json http://riegel.canyon.it23.com/api/auth/login```

## Output:

![Picture5](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/aae501cb-bcd4-4fcc-ad48-38fccd80383e)


Pada FFF Worker
mengecek log pada ```cat /var/log/nginx/deploy_access.log```

## Output:

#### Frieren
![Picture6](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/db2a119b-c82e-48f2-b3a6-fb1e83c38a9d)

#### Frieren
![Picture7](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/0b9b2b16-f6d2-4b03-b878-24f1af13e347)

#### Fern
![Picture8](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/2696a00d-40db-4e31-8680-d05fbdc3cb75)

### Soal 19
#### Description :
Untuk meningkatkan performa dari Worker, coba implementasikan PHP-FPM pada Frieren, Flamme, dan Fern. Untuk testing kinerja naikkan 
- pm.max_children
- pm.start_servers
- pm.min_spare_servers
- pm.max_spare_servers
sebanyak tiga percobaan dan lakukan testing sebanyak 100 request dengan 10 request/second

#### PoC :
Implementasikan PHP-FPM pada 3 Laravel Worker

**Frieren**

Menerapkan ke 3 percobaan dengan config :
#### test1.sh 
```bash
#!/bin/bash
echo '[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 3
pm.start_servers = 4
pm.min_spare_servers = 2
pm.max_spare_servers = 5' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.2-fpm restart
```
#### test2.sh
```bash
echo '[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 6
pm.start_servers = 5
pm.min_spare_servers = 3
pm.max_spare_servers = 10' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.2-fpm restart
```

#### test3.sh
```bash
echo '[www]
user = www-data
group = www-data
listen = /run/php/php8.0-fpm.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = 9
pm.start_servers = 6
pm.min_spare_servers = 4
pm.max_spare_servers = 11' > /etc/php/8.0/fpm/pool.d/www.conf

service php8.2-fpm restart
```

## Output:
#### test1.sh
![Picture9](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/bf5fd774-7d12-4943-9e7d-48eb3d507ea0)

#### test2.sh
![Picture10](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/c8560b90-76a0-42ab-b34f-3ca9e3e7c648)

#### test3.sh
![Picture11](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/f543a64d-ce85-41a7-8efa-423ce1b81fa3)


### Soal 20
#### Description :
Nampaknya hanya menggunakan PHP-FPM tidak cukup untuk meningkatkan performa dari worker maka implementasikan Least-Conn pada Eisen. Untuk testing kinerja dari worker tersebut dilakukan sebanyak 100 request dengan 10 request/second. 

#### PoC :
Implementasikan **Least-Conn** oada Eisen :
```bash
echo '
upstream worker {
    least_conn;
    server 10.75.4.1:8001;
    server 10.75.4.2:8002;
    server 10.75.4.3:8003;
}
```

## Output:

![Picture12](https://github.com/RenDaemon/Jarkom-Modul-3-IT23-2023/assets/89828723/66ecf397-b328-4cbf-83fc-904792d45eeb)

