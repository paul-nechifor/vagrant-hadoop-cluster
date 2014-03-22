# Add Hadoop commands to the path for easier SSH-ing.
echo "export HADOOP_PREFIX=/opt/hadoop" >> ~/.bashrc
echo "export PATH=\$PATH:/opt/hadoop/bin" >> ~/.bashrc
