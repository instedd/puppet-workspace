# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  # Make VMs available using the hostname in the local machine
  config.vm.network :private_network, type: :dhcp
  config.vm.provision :shell, inline: %(
    export DEBIAN_FRONTEND=noninteractive
    wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
    sudo dpkg -i puppetlabs-release-precise.deb
    rm puppetlabs-release-precise.deb
    sudo apt-get update
    sudo apt-get -y install avahi-daemon
  )

  config.vm.define "master" do |c|
    c.vm.box = "precise64"
    c.vm.box_url = "http://files.vagrantup.com/precise64.box"
    c.vm.hostname = "puppet-master.local"
    c.vm.provision :shell, inline: "sudo apt-get -y install puppetmaster"

    # c.vm.synced_folder ".", "/vagrant", type: "nfs"
  end

  config.vm.define "client" do |c|
    c.vm.hostname = "puppet-client.local"
    c.vm.provision :shell, inline: "sudo apt-get -y install puppet"
  end

  config.vm.define "resmap" do |c|
    c.vm.hostname = "resmap.local"
    c.vm.provision :shell, inline: "sudo apt-get -y install puppet"
  end

end
