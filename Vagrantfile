# -*- mode: ruby -*-
# vi: set ft=ruby :

vm_name = "orange.local"
vm_memory = "1024"
vm_cpus = "2"
vm_hostname = "orange.local"

hm_project_dir = "."

box_name = "ubuntu/trusty64"
vm_project_dir = "/orange"


VAGRANTFILE_API_VERSION = '2'

@script = <<SCRIPT
DOCUMENT_ROOT_ZEND="/var/www/zf/public"
apt-get update
apt-get install -y apache2 git curl php5-cli php5 php5-intl libapache2-mod-php5
echo "
<VirtualHost *:80>
    ServerName skeleton-zf.local
    DocumentRoot $DOCUMENT_ROOT_ZEND
    <Directory $DOCUMENT_ROOT_ZEND>
        DirectoryIndex index.php
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>
" > /etc/apache2/sites-available/skeleton-zf.conf
a2enmod rewrite
a2dissite 000-default
a2ensite skeleton-zf
service apache2 restart
cd /var/www/zf
curl -Ss https://getcomposer.org/installer | php
php composer.phar install --no-progress
echo "** [ZEND] Visit http://localhost:8085 in your browser for to view the application **"
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.provider "virtualbox" do |v|
       v.name = vm_name
       v.memory = vm_memory
       v.cpus = vm_cpus
    end

  # Vagrant box initialization
  config.vm.box = box_name

  # Networking and mounted dirs
  config.vm.hostname = vm_hostname
  config.vm.network 'private_network', type: 'dhcp'
  config.vm.synced_folder hm_project_dir, vm_project_dir, owner: "www-data", group: "www-data"

  # Hostmanager configuration
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = false
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  # IP resolver
  config.hostmanager.ip_resolver = proc do |vm|
      result = ''
      vm.communicate.execute("ip -f inet addr | egrep '^\s*inet\s+' | tail -n1 | awk -F' ' '{print $2}' | cut -d'/' -f1") do |type, data|
          result << data if type == :stdout
      end
      unless result.empty?
          result.split("\n").first
      end
  end

  #config.vm.provision 'shell', inline: @script
  
  # Provisioning
  config.vm.provision "shell" do |s|
    s.path = "./install_5_4_dev_env.sh"
    s.args = ["-a"]
  end

end
