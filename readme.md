# Vagrant Hadoop Cluster

A mini Hadoop cluster configuration in Vagrant.

## Set Up

Bring up the machines:

    vagrant up

Log into the master:

    vagrant ssh master

## On Master

From master, you have to connect to all the slaves. Run this script which
loops through all the SSH authentications. Exit every one.

    bash /vagrant/scripts/ssh-checkin.sh

Format the name node:

    hadoop namenode -format

Start everything:

    start-all.sh

Check the web interface at [10.10.10.10:50070](http://10.10.10.10:50070).

## License

MIT
