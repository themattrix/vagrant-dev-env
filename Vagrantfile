# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    # Define an Ubuntu Trusty (14.04) x64 machine
    config.vm.define "ubuntu" do |ubuntu|
        ubuntu.vm.box     = "trusty64"
        ubuntu.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    end

    # Define a CentOS 6.4 x64 machine
    config.vm.define "centos" do |centos|
        centos.vm.box     = "centos64"
        centos.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
    end

    # Use Puppet to bootstrap Ansible on the VM.
    config.vm.provision "puppet" do |puppet|
        puppet.manifests_path = "provisioning/puppet/manifests"
        puppet.manifest_file  = "bootstrap_ansible.pp"
    end

    # Use Ansible to provision the rest of the system.
    config.vm.provision "shell" do |script|
        script.inline = "PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ansible-playbook /vagrant/provisioning/ansible/playbook.yml"
        script.privileged = false
        script.keep_color = true
    end
end
