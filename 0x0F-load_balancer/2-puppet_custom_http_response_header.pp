# Automate the creation of a custom HTTP header response using Puppet

# Update system packages
exec {'system_update':
  command => '/usr/bin/apt-get update',
}

# Ensure Nginx is installed
-> package {'nginx_package':
  ensure => 'present',
}

# Add custom HTTP header to Nginx configuration
-> file_line { 'custom_http_header':
  path  => '/etc/nginx/nginx.conf',
  match => 'http {',
  line  => "http {\n\tadd_header X-Custom-Header \"${hostname}\";",
}

# Restart Nginx service to apply changes
-> exec {'service_restart':
  command => '/usr/sbin/service nginx restart',
}

