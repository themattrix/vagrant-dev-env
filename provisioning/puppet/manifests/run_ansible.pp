# Ensure apt database has been updated before any packages are installed
Exec['apt-get-update'] -> Package<| |>

Exec {
  path => ['/usr/local/sbin', '/usr/sbin', '/sbin', '/usr/local/bin', '/usr/bin', '/bin'],
}

exec { 'add-ansible-repo':
  command   => 'add-apt-repository -y ppa:rquillo/ansible',
  creates   => '/etc/apt/trusted.gpg.d/rquillo-ansible.gpg',
  logoutput => true,
}

exec { 'apt-get-update':
  command => 'apt-get update',
  require => Exec['add-ansible-repo'],
  onlyif  => '[ $(($(date +%s) - $(date +%s -d "$(stat -c %y /var/lib/apt/periodic/update-success-stamp)"))) -gt 3600 ]',
}

package { 'ansible':
  ensure  => installed,
}

file { '/etc/ansible/hosts':
  source  => '/vagrant/provisioning/ansible/config/hosts',
  links   => follow,
  require => Package['ansible'],
}

exec { 'bootstrap-ansible':
  user        => 'vagrant',
  environment => ['HOME=/home/vagrant', 'USER=vagrant'],
  command     => 'ansible-playbook /vagrant/provisioning/ansible/playbook.yml',
  logoutput   => true,
  timeout     => 0,
  require     => [
    File['/etc/ansible/hosts'],
  ]
}
