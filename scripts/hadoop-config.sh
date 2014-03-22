# Copy all the Hadoop configuration files.
cp /vagrant/files/hadoop-conf/* /opt/hadoop/conf

mkdir /opt/hadoop/logs
chown vagrant:vagrant /opt/hadoop/logs
