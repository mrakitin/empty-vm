Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-23.04"
  config.vm.box_check_update = true

  config.vbguest.auto_update = false if Vagrant.has_plugin?("vagrant-vbguest")

  config.vm.network "private_network", ip: "192.168.56.0"
  config.vm.network "forwarded_port", guest: 8000, host: 8000, host_ip: "127.0.0.1"  # flask port
  config.vm.network "forwarded_port", guest: 8888, host: 8888, host_ip: "127.0.0.1"  # jupyter port
  config.vm.network "forwarded_port", guest: 27017, host: 27017, host_ip: "127.0.0.1"  # mongodb port

  # config.vm.synced_folder ".", "/repo"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "empty-vm"
    vb.gui = false
    # vb.memory = "4096"
    # vb.cpus = 4
  end

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  $script_root = "/bin/bash --login /vagrant/setup-under-root.sh"
  config.vm.provision "shell", privileged: true, inline: $script_root

  # Reboot between the sudo and regular user steps to pick up the new 'docker' group.
  #   https://developer.hashicorp.com/vagrant/docs/provisioning/shell#reboot
  config.vm.provision "shell", reboot: true

  $script_vagrant = "/bin/bash --login /vagrant/setup-under-vagrant.sh"
  config.vm.provision "shell", privileged: false, inline: $script_vagrant

end
