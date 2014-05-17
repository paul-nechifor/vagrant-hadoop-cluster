# Add Hadoop commands to the path for easier SSH-ing.
echo "export HADOOP_PREFIX=/opt/hadoop" >> ~/.bashrc
echo "export HADOOP_HOME=/opt/hadoop" >> ~/.bashrc
echo "export HADOOP_VERSION=1.2.1" >> ~/.bashrc
echo "export PATH=\$PATH:/opt/hadoop/bin" >> ~/.bashrc
