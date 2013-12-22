# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # Define an Ubuntu Saucy (13.04) x64 machine
    config.vm.define "ubuntu" do |ubuntu|
        ubuntu.vm.box     = "saucy64"
        ubuntu.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/saucy/current/saucy-server-cloudimg-amd64-vagrant-disk1.box"
    end

    # Define a CentOS 6.4 x64 machine
    config.vm.define "centos" do |centos|
        centos.vm.box     = "centos64"
        centos.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
    end

    # Initially with Puppet for the sole purpose of installing and running Ansible on the VM.
    config.vm.provision "puppet" do |puppet|
        puppet.manifests_path = "provisioning/puppet/manifests"
        puppet.manifest_file  = "run_ansible.pp"
    end
end
