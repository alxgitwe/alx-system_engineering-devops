# Automate the task of creating a custom HTTP header response using Puppet

# Update system packages
exec { 'update_system_packages':
  command => '/usr/bin/apt-get update',
}

# Ensure Nginx is installed
-> package { 'nginx_package':
  ensure => 'present',
}

# Add a custom HTTP header to Nginx configuration
-> file_line { 'add_custom_http_header':
  path  => '/etc/nginx/nginx.conf',
  line  => "add_header X-Served-By \"${hostname}\";",
  after => 'http {',
}

# Restart the Nginx service to apply changes
-> exec { 'restart_nginx_service':
  command => '/usr/sbin/service nginx restart',
}

