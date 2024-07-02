# script puppet
define ssh_config_line(
  Enum['present', 'absent'] $ensure = 'present',
  String $line,
  String $path = '/etc/ssh/ssh_config',
) {
  file_line { $title:
    ensure => $ensure,
    path   => $path,
    line   => $line,
  }
}

# Use the custom resource type to manage the SSH config file
ssh_config_line { 'Turn off passwd auth':
  line => '    PasswordAuthentication no',
}

ssh_config_line { 'Declare identity file':
  line => '    IdentityFile ~/.ssh/school',
}

