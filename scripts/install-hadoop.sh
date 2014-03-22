#!/bin/bash

HADOOP_TAR="http://mirrors.hostingromania.ro/apache.org/hadoop/common/hadoop-2.3.0/hadoop-2.3.0.tar.gz"
HADOOP_LOC="/opt/hadoop"

function installReq() {
    apt-get update
    apt-get -y install openjdk-7-jdk
}

function installHadoop() {
    wget "$HADOOP_TAR"
    tar -xvzf hadoop-*.tar.gz
    rm hadoop-*.tar.gz
    mv hadoop-* "$HADOOP_LOC"
}

# TODO: Execute this for the normal user.
function installForUser() {
    echo "export HADOOP_PREFIX=$HADOOP_LOC" >> ~/.bashrc
    echo "export PATH=\$PATH:$HADOOP_LOC/bin" >> ~/.bashrc
}

function main() {
    installReq
    installHadoop
}

main
