boxes = [
  {
      :name => "#{ENV['COMPUTERNAME'] || `hostname`[0..-2]}-devops",
      :eth1 => '192.168.199.9',
      :groups => "/vagrant",
      :mem => "2048",
      :cpu => "2"
  },
]

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/bionic64"

  boxes.each do |opts|
    config.vm.define opts[:name] do |devbox|
         devbox.vm.hostname = opts[:name]
         devbox.vm.network "private_network", ip: opts[:eth1]
         devbox.vm.network "public_network", use_dhcp_assigned_default_route: true
         devbox.vm.network "forwarded_port", guest: 8080, host: 8080 # jenkins master port
	 devbox.vm.network "forwarded_port", guest: 50000, host: 50000  # jenkins slave port
	 devbox.vm.network "forwarded_port", guest: 80, host: 89  # http  port
	    
        devbox.vm.provider "virtualbox" do |v|
            v.customize ["modifyvm", :id, "--memory", opts[:mem]]
            v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
            v.customize ["modifyvm", :id, "--groups", opts[:groups]]            
            v.name = opts[:name]
            v.gui = false
        end

	 devbox.vm.provision "shell", path: "scripts/install.sh"

     devbox.vm.provision "shell", path: "scripts/jenkins.sh"

    end
  end
end
