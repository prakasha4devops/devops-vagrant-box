boxes = [
  {
      :name => "#{ENV['COMPUTERNAME'] || `hostname`[0..-2]}-devops",
      :eth1 => '192.168.10.10',
      :groups => "/vagrant",
      :mem => "8056",
      :cpu => "4"
  },
]

Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-20.04" #ubuntu/bionic64

  boxes.each do |opts|
    config.vm.define opts[:name] do |devbox|
         devbox.vm.hostname = opts[:name]
         devbox.vm.network "private_network", ip: opts[:eth1]
         devbox.vm.network "public_network", use_dhcp_assigned_default_route: true
         devbox.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: true #ssh port
         devbox.vm.network :forwarded_port, guest: 22, host: 2210,  auto_correct: true  #ssh port

         devbox.vm.network "forwarded_port", guest: 8080, host: 8080 # jenkins master port
         devbox.vm.network "forwarded_port", guest: 8081, host: 8081 # jenkins - docker master port
	     devbox.vm.network "forwarded_port", guest: 50000, host: 50000  # jenkins slave port
	     devbox.vm.network "forwarded_port", guest: 80, host: 80  # http  port
	     devbox.vm.network "forwarded_port", guest: 8090, host: 8090  # 8090  port
         devbox.vm.network "forwarded_port", guest: 5432, host: 5432  # 5432 postgres port
         devbox.vm.network "forwarded_port", guest: 8070, host: 8070  # 8070 postgres port
         devbox.vm.network "forwarded_port", guest: 9200, host: 9200  # 9200 Elasticsearch  port
         devbox.vm.network "forwarded_port", guest: 9300, host: 9300  # 9300 Elasticsearch  port
         devbox.vm.network "forwarded_port", guest: 8200, host: 8200  # 8200 vault port
		 devbox.vm.network "forwarded_port", guest: 8000, host: 8000 # django python port
		 devbox.vm.network "forwarded_port", guest: 3306, host: 3306 # mysql 3306 port


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
            ansible.playbook = "/vagrant/ansible_playbook/playbook.yml"
        end

#       if File.directory?(File.expand_path("E:/work/projects"))
#           devbox.vm.synced_folder "E:/work/projects", "/vagrant/projects",type: "virtualbox"
#       end

    end
  end
end
