username=vagrant
s=/vagrant/scripts

bash $s/packages-install.sh
bash $s/hadoop-install.sh
bash $s/hadoop-config.sh
bash $s/hadoop-config-user.sh
bash $s/replace-hosts.sh

su $username -c "bash $s/hadoop-config-user.sh"
su $username -c "bash $s/ssh-authorize-master.sh"
