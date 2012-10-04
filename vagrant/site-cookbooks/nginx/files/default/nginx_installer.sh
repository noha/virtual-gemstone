
#based on http://thekindofme.wordpress.com/2010/11/19/ubuntu-10-04-nginx-with-upload-and-upload-progress-modules-rvm-postgresql/
#and http://wiki.nginx.org/Modules for the ssl magic
#installs and runs (don't know how to stop ;) ). reports OpenSSL present and used by a couple of things.
wget -N http://nginx.org/download/nginx-1.2.4.tar.gz
tar xzf nginx-1.2.4.tar.gz
wget -N --no-check-certificate https://github.com/gnosek/nginx-upstream-fair/tarball/master
mv master nginx-upstream-fair-a18b409.tgz
tar -xvzf nginx-upstream-fair-a18b409.tgz
wget http://www.grid.net.ru/nginx/download/nginx_upload_module-2.2.0.tar.gz
tar zxf nginx_upload_module-2.2.0.tar.gz
cd nginx-1.2.4
CFLAGS+=-O2 \
./configure --conf-path=/etc/nginx/nginx.conf \
--with-cpu-opt=amd64 \
--error-log-path=/var/log/nginx/error.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/lock/nginx.lock \
--http-log-path=/var/log/nginx/access.log \
--http-client-body-temp-path=/var/lib/nginx/body \
--http-proxy-temp-path=/var/lib/nginx/proxy \
--http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
--http-scgi-temp-path=/var/lib/nginx/scgi_temp \
--http-uwsgi-temp-path=/var/lib/nginx/uwsgi_temp \
--with-debug \
--with-http_stub_status_module \
--with-http_flv_module \
--with-http_ssl_module \
--with-http_dav_module \
--with-http_gzip_static_module \
--with-http_realip_module \
--with-mail \
--with-mail_ssl_module \
--with-ipv6 \
--add-module=../gnosek-nginx-upstream-fair-a18b409/ \
--add-module=../masterzen-nginx-upload-progress-module-a788dea/ \
--add-module=../nginx_upload_module-2.2.0/ \
--with-cc-opt='-pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' 


make
strip objs/nginx
sudo make install