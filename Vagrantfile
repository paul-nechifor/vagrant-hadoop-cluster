nSlaves = 3

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise32"

  config.vm.define "master" do |master|
    master.vm.host_name = "master"
    master.vm.network "private_network", ip: "10.10.10.10"
    master.vm.provider "virtualbox" do |v|
      v.name = "master"
      v.memory = 1024
      v.cpus = 2
    end
  end

  (1..nSlaves).each do |i|
    vmname = "slave#{i}"
    config.vm.define vmname.to_sym do |slave|
      slave.vm.host_name = vmname
      slave.vm.network "private_network", ip: "10.10.10.#{10+i}"
      slave.vm.provider "virtualbox" do |v|
        v.name = vmname
        v.memory = 512
        v.cpus = 1
      end
    end
  end
end
