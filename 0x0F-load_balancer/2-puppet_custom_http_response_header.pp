# Automate the creation of a custom HTTP header response using Puppet

# Update system packages
exec { 'system_update':
  command  => '/usr/bin/apt-get -y update',
}

# Ensure Nginx is installed
-> package { 'nginx_package':
  ensure => 'present',
}

# Add custom HTTP header to Nginx configuration
-> file_line { 'add_custom_header':
  path  => '/etc/nginx/sites-available/default',
  line  => 'add_header X-Served-By $HOSTNAME;',
}

# Restart Nginx service to apply changes
-> exec { 'service_restart':
  command => '/usr/sbin/service nginx restart',
}

