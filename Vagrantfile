# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # SSH Agent Forwarding
  config.ssh.forward_agent = true

  config.vm.box = "ubuntu1410"
  config.vm.hostname = "nibley-selenium"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/utopic/current/utopic-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.network :forwarded_port, guest: 3000, host: 5000, auto_correct: true

  #need to wait till nfs is installed on guest before mounting with nfs: 
  config.vm.synced_folder "./", "/home/vagrant/nibley_selenium"

  # shell provisioning 

rootuser = <<SCRIPT
  apt-get -y install git
  apt-get -y install zip
  apt-get -y install libssl-dev
  apt-get -y install ruby-dev
  chmod 777 /var/lib
SCRIPT

vagrantuser = <<SCRIPT
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
SCRIPT

vagrantnewshell = <<SCRIPT
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  rbenv install 2.1.5
  which gem
  echo "***********"
  sudo /home/vagrant/.rbenv/shims/gem install --no-ri --no-rdoc bundler
  cd ~/nibley_selenium && bundle install
  cd ~/nibley_selenium && wget https://www.browserstack.com/browserstack-local/BrowserStackLocal-linux-x64.zip
SCRIPT
  
  config.vm.provision "shell", inline: rootuser
  config.vm.provision "shell", inline: vagrantuser, privileged: false
  config.vm.provision "shell", inline: vagrantnewshell, privileged: false

end

