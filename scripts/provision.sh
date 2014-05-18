hadoop_tar="http://www.eu.apache.org/dist/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz"
username=vagrant
n_slaves=-1

main() {
  n_slaves=$2

  case $1 in
    master)
      master $@ ;;
    slave)
      slave $@ ;;
    user)
      user $@ ;;
    ssh-checkin)
      ssh_checkin ;;
  esac
}

master() {
  common $@
  master_ssh_config # TODO: Is this really needed here?
}

slave() {
  common $@
}

user() {
  config_hadoop_user
  ssh_authorize_master
  if [ "$3" == "master" ]; then
    master_ssh_config
  fi
}

ssh_checkin() {
  # Connect to all VMs (master too) to establish the keys.
  for (( i=0; i <=$n_slaves; i++ )); do
    ssh -o 'StrictHostKeyChecking=no' 10.10.10.$((10+$i))
  done
}

common() {
  install_packages
  install_hadoop
  config_hadoop
  generate_hosts_file > /etc/hosts

  su $username -c "bash /vagrant/scripts/provision.sh user $n_slaves $1"
}

install_packages() {
  apt-get update
  apt-get -y install openjdk-7-jdk
}

master_ssh_config() {
  mkdir ~/.ssh 2>/dev/null
  cp /vagrant/files/ssh/* ~/.ssh
  chmod 600 ~/.ssh/*
}

install_hadoop() {
  if [ -d "/opt/hadoop" ]; then
    echo "I think you have hadoop. Not installing it."
    return
  fi

  rm hadoop-*.tar.gz # In case it was there.
  wget "$hadoop_tar"
  tar -xzf hadoop-*.tar.gz
  rm hadoop-*.tar.gz
  mv hadoop-* /opt/hadoop
}

config_hadoop() {
  # Copy all the Hadoop configuration files.
  cp /vagrant/files/hadoop-conf/* /opt/hadoop/conf
  generate_slaves_file > /opt/hadoop/conf/slaves

  # Make the logs dir writable by the normal user.
  mkdir /opt/hadoop/logs 2>/dev/null
  chown $username:$username /opt/hadoop/logs
}

generate_hosts_file() {
  echo 127.0.0.1 localhost
  echo 10.10.10.10 master
  for (( i=1; i <=$n_slaves; i++ )); do
    echo 10.10.10.$((10+$i)) slave$i
  done
}

generate_slaves_file() {
  for (( i=1; i <=$n_slaves; i++ )); do
    echo 10.10.10.$((10+$i))
  done
}

config_hadoop_user() {
  # Add Hadoop commands to the path for easier SSH-ing.
  echo "export PATH=\$PATH:/opt/hadoop/bin" >> ~/.bashrc

  echo "export HADOOP_PREFIX=/opt/hadoop" >> ~/.bashrc
  echo "export HADOOP_VERSION=1.2.1" >> ~/.bashrc
}

ssh_authorize_master() {
  cat /vagrant/files/ssh/id_rsa.pub >> ~/.ssh/authorized_keys
}

main $@
