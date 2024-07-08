#!/usr/bin/env bash
# Automate the task to create a custom HTT header response with Puppet

exec { 'nginx install':
path    => '/usr/bin',
command => 'sudo apt update && sudo apt-get -y install nginx',
}

exec { 'Make directories':
path    => '/usr/bin',
command => 'sudo mkdir -p /var/www/html && sudo chown -R "$USER":"$USER" /var/www/html',
}

# exec { 'Make file':
# path    => '/usr/bin',
# command => 'echo "Hello World!" > /var/www/html/index.html'
# }

file { '/var/www/html/index.html':
mode    => '0755',
content => 'Hello World!',
}

file {'/var/www/html/error404.html':
mode    => '0755',
content => "Ceci n'est pas une page",
}

exec { 'block server':
path    => '/usr/bin',
command => 'echo "
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;
	index index.html index.htm index.nginx-debian.html;

	add_header X-Served-By \$hostname;

	error_page 404 /error404.html;
	location = /error404.html {
		root /var/www/html;
		internal;
	}

	location /redirect_me {
		return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
	}
}" | sudo tee /etc/nginx/sites-available/default'
}

exec { 'Restart nginx':
path    => '/usr/bin',
command => 'sudo service nginx restart',
}
