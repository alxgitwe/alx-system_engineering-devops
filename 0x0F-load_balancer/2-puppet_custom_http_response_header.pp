# Utilize Puppet to streamline the process of generating a personalized HTTP header response

# Update the package list
Exec {'refresh':
  command => '/usr/bin/apt-get update',
}

# Ensure Nginx is installed
Package {'nginx':
  ensure => 'installed',
  require => Exec['refresh'],
}

# Add a custom HTTP header to the Nginx configuration file
File_line {'custom_http_header':
  path  => '/etc/nginx/nginx.conf',
  match => 'http {',
  line  => "http {\n\tadd_header X-Served-By \"${hostname}\";",
  require => Package['nginx'],
}

# Restart Nginx to apply the changes
Exec {'restart':
  command => '/usr/sbin/service nginx reload',
  require => [Package['nginx'], File_line['custom_http_header']],
}
