server {
    listen 80;
    server_name .juwai.dev;

    # dynamic vhosts for development
    #set $basepath "/var/www/developer/taojun";
    set $basepath "/var/www/developer";

    #if ($host ~* ^(.*)\.*$){
    #if ($host ~* ^([^\.]+)\.*) {
    if ($host ~* ^([^\.]+)\.([^\.]+)\.*) {
        set $domain $1;
	set $project $2;
    }

    add_header app $domain;
    if (-d $basepath/$domain/$project/web) {
        set $rootpath "${domain}/${project}/web/";
    }
    root $basepath/$rootpath;

    add_header Root $basepath/$rootpath;

    error_log /var/log/nginx/$developer.symfony.error.log;
    access_log /var/log/nginx/$developer.symfony.access.log;

    # strip app.php/ prefix if it is present
    # rewrite ^/app_dev\.php/?(.*)$ /$1 permanent;

    location / {
        index app_dev.php;
        try_files $uri @rewriteapp;
    }

    location @rewriteapp {
        rewrite ^(.*)$ /app_dev.php/$1 last;
    }

    location ~ ^/(app|app_dev)\.php(/|$) {
        fastcgi_buffer_size 128k;
        fastcgi_buffers 4 256k;
        fastcgi_busy_buffers_size 256k;

        fastcgi_pass  unix:/var/run/php5-fpm.sock; 
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        #fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
        fastcgi_param  HTTPS              off;
    }
}

