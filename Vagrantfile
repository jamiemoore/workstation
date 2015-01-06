# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  #Add the vms to each others host file
  config.hostmanager.enabled = true
  #Add entry to local hosts file
  config.hostmanager.manage_host = true

  #Enable VMWare Workstation GUI 
  config.vm.provider "vmware_workstation" do |v|
    v.gui = true
  end

  #Shell Provisioner
  #config.vm.provision "shell", path: "setup"

  config.vm.define "workstation" do |workstation|
    #workstation.vm.box = "puppetlabs/centos-7.0-64-puppet"
    workstation.vm.box = "puppetlabs/centos-7.0-64-nocm"
    workstation.vm.hostname = "workstation.internal"
    workstation.hostmanager.aliases = %w( workstation )
    workstation.vm.box_download_insecure = true
    workstation.vm.provision "shell", path: "vagrant_centos7.sh"
  end

end
