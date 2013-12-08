# Ensure apt database has been updated before any packages are installed
Exec['apt-get-update'] -> Package<| |>

exec { 'add-ansible-repo':
  path      => ['/bin', '/usr/bin'],
  command   => 'add-apt-repository -y ppa:rquillo/ansible',
  creates   => '/etc/apt/trusted.gpg.d/rquillo-ansible.gpg',
  logoutput => true,
}

exec { 'apt-get-update':
  path    => ['/bin', '/usr/bin'],
  command => 'apt-get update',
  require => Exec['add-ansible-repo'],
  onlyif  => '[ $(($(date +%s) - $(date +%s -d "$(stat -c %y /var/lib/apt/periodic/update-success-stamp)"))) -gt 3600 ]',
}

package { 'ansible':
  ensure  => installed,
}

file { '/etc/ansible/hosts':
  content => 'localhost',
  require => Package['ansible'],
}

exec { 'run-ansible':
  path      => ['/bin', '/usr/bin', '/sbin', '/usr/sbin', '/usr/local/sbin'],
  command   => 'ansible-playbook /vagrant/provisioning/ansible/playbook.yml --connection=local',
  logoutput => true,
  timeout   => 0,
  require   => File['/etc/ansible/hosts']
}
