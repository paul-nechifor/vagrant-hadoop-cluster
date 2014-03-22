username=vagrant
s=/vagrant/scripts

bash $s/packages-install.sh
bash $s/hadoop-install.sh

su $username -c "bash $s/hadoop-config.sh"
