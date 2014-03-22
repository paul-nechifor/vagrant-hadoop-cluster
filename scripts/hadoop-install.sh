HADOOP_TAR="http://mirrors.hostingromania.ro/apache.org/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz"

if [ -d "/opt/hadoop" ]; then
    echo "I think you have hadoop. Not installing it."
    exit
fi

wget "$HADOOP_TAR"
tar -xvzf hadoop-*.tar.gz
rm hadoop-*.tar.gz
mv hadoop-* /opt/hadoop
