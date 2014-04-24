server {
	listen 80;
	server_name .juwai.cc .juwai.local;

	set $basepath "/var/www/developer";

	if ($host ~* ^([^\.]+)\.([^\.]+)\.*) {
		set $developer $1;
		set $project $2;
	}

	set $rootpath 404;
	if (-e $basepath/$developer/$project){
		set $rootpath $developer/$project/;
	}

	#add_header JW-DEV $developer;
	#add_header JW-DEV-HOST $host;
	#add_header JW-DEV-TEST $basepath/$developer/$project;
	#add_header JW-DEV-ROOT $basepath/$rootpath;

	root $basepath/$rootpath;
	
	access_log /var/log/nginx/$developer.local.access.log;
	error_log /var/log/nginx/$developer.local.error.log;

	index index.php index.html index.htm;

	location / {
		error_page 418 = @rewrite_juwai;
		if ($project = www ) {
			return 418;
		}
		error_page 419 = @rewrite_mobile;
		if ($project = mobile ) {
			return 419;
		}
	}

	location @rewrite_juwai {
		include /etc/nginx/rewrite_juwai.conf;
	}
	location @rewrite_mobile {
		include /etc/nginx/rewrite_mobile.conf;
	}


	location ~ \.php$ {
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		fastcgi_index index.php;
		include fastcgi_params;
	}
}
log_format devlog '${basepath}/${developer}/{$project}' 
                  '$remote_addr - $remote_user [$time_local] "$request" '  
                  '$status $body_bytes_sent "$http_referer" '  
                  '"$http_user_agent" "$http_x_forwarded_for"';  
