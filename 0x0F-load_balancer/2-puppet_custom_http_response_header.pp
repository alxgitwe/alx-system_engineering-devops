# Use Puppet to automate the task of creating a custom HTTP header response

# Define the package name and service name
$package_name = 'nginx'
$service_name = 'nginx'

# Update the package list
exec {'update':
  command => '/usr/bin/apt-get update',
}

# Ensure the package is installed
package {$package_name:
  ensure => 'present',
  require => Exec['update'],
}

# Add a custom HTTP header to the configuration file
file_line {'http_header':
  path  => "/etc/${package_name}/${package_name}.conf",
  match => 'http {',
  line  => "http {\n\tadd_header X-Served-By \"${hostname}\";",
  require => Package[$package_name],
}

# Restart the service to apply the changes
exec {'run':
  command => "/usr/sbin/service ${service_name} restart",
  require => File_line['http_header'],
}

