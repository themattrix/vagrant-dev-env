# Vagrant user should be able to SSH to localhost without a problem

$vagrant_ssh_dir = '/home/vagrant/.ssh'

file { "$vagrant_ssh_dir":
  ensure => directory,
  owner  => 'vagrant',
  group  => 'vagrant',
  mode   => '0644',
} ->

exec { 'generate-local-ssh-key':
  path    => ['/bin', '/usr/bin'],
  cwd     => "$vagrant_ssh_dir",
  user    => 'vagrant',
  command => 'ssh-keygen -t rsa -b 4096 -N "" -f id_rsa',
  creates => "$vagrant_ssh_dir/id_rsa",
} ->

exec { 'authorize-ssh-key':
  path    => ['/bin', '/usr/bin'],
  cwd     => "$vagrant_ssh_dir",
  user    => 'vagrant',
  command => "cat id_rsa.pub >> authorized_keys",
  unless  => 'grep -sqFx "$(cat id_rsa.pub)" authorized_keys',
} ->

file { "$vagrant_ssh_dir/authorized_keys":
  owner => 'vagrant',
  group => 'vagrant',
  mode  => '0400',
} ->

exec { 'add-localhost-to-known-hosts':
  path    => ['/bin', '/usr/bin'],
  cwd     => "$vagrant_ssh_dir",
  user    => 'vagrant',
  command => 'ssh-keyscan -t rsa localhost >> known_hosts',
  unless  => 'grep -sq "^localhost " known_hosts',
}


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
  user      => 'vagrant',
  command   => 'ansible-playbook /vagrant/provisioning/ansible/playbook.yml',
  logoutput => true,
  timeout   => 0,
  require   => [
    File['/etc/ansible/hosts'],
    Exec['add-localhost-to-known-hosts'],
  ]
}
