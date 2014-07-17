#!/bin/sh
###
server {
listen 80;
server_name cloud.mondomaine.com;
root /var/www/owncloud;
client_max_body_size 1000M;
index index.php;
dav_methods PUT DELETE MKCOL COPY MOVE;
create_full_put_path on;
dav_access user:rw group:rw all:r;
try_files $uri $uri/ @webdav;
location @webdav {
fastcgi_split_path_info ^(.+.php)(/.+)$;
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
include fastcgi_params;
fastcgi_pass 127.0.0.1:9000;
}
# PHP scripts -> PHP-FPM server listening on 127.0.0.1:9000
location ~ .php$ {
try_files $uri =404;
fastcgi_pass 127.0.0.1:9000;
fastcgi_index index.php;
include fastcgi_params;
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
}
# Stuffs
location = /favicon.ico {
access_log off;
return 204;
}
# Protect hidden file to read/write access
location ~ /. {
deny all;
}
}
[/cc]
On relance NGinx:
[cc]
sudo /etc/init.d/nginx reload
