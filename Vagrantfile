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
         devbox.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: true #ssh port
         devbox.vm.network :forwarded_port, guest: 22, host: 2210,  auto_correct: true  #ssh port

         devbox.vm.network "forwarded_port", guest: 8080, host: 8080 # jenkins master port
	       devbox.vm.network "forwarded_port", guest: 50000, host: 50000  # jenkins slave port
	       devbox.vm.network "forwarded_port", guest: 80, host: 80  # http  port
	       devbox.vm.network "forwarded_port", guest: 8090, host: 8090  # 8090  port
           devbox.vm.network "forwarded_port", guest: 5432, host: 5432  # 5432 postgres port


        devbox.vm.provider "virtualbox" do |v|
            v.customize ["modifyvm", :id, "--memory", opts[:mem]]
            v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
            v.customize ["modifyvm", :id, "--groups", opts[:groups]]            
            v.name = opts[:name]
            v.gui = false
        end

	   devbox.vm.provision "shell", path: "scripts/install.sh"


      devbox.vm.provision "ansible_local" do |ansible|
            ansible.verbose = true
            ansible.playbook = "/vagrant/ansible_playbook/deploy-docker.yml"
        end

      if File.directory?(File.expand_path("E:/work/projects"))
          devbox.vm.synced_folder "E:/work/projects", "/vagrant/projects",type: "virtualbox"
      end

    end
  end
end
