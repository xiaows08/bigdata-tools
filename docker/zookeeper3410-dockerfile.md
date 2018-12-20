[TOC]
## Dockerfile-zookeeper3410-jdk
```docker
#zookeeper3410-jdk.dockerfile

# |-- zookeeper3410-jdk.dockerfile
# `-- zookeeper-3.4.10
#     |-- LICENSE.txt
#     |-- NOTICE.txt
#     |-- README.txt
#     |-- README_packaging.txt
#     |-- bin
#     |-- build.xml
#     |-- cluster-zk.sh
#     |-- conf
#     |-- contrib
#     |-- dist-maven
#     |-- ivy.xml
#     |-- ivysettings.xml
#     |-- lib
#     |-- recipes
#     |-- zookeeper-3.4.10.jar
#     |-- zookeeper-3.4.10.jar.asc
#     |-- zookeeper-3.4.10.jar.md5
#     `-- zookeeper-3.4.10.jar.sha1

FROM xiaows/debian8-jdk8-ssh:3.0

# TODO download & decompression & config(modify conf/zoo.cfg) it, then put cluster-zk.sh to it.
ADD zookeeper-3.4.10/ /usr/local/zookeeper-3.4.10
ENV ZOOKEEPER_HOME=/usr/local/zookeeper-3.4.10
ENV PATH=$PATH:$ZOOKEEPER_HOME/bin

WORKDIR $ZOOKEEPER_HOME

RUN mkdir -p /data/zkData;\
    rm -rfv $ZOOKEEPER_HOME/bin/*.cmd;\
    chmod +x cluster-zk.sh;

COPY zookeeper3410-jdk.dockerfile /
```

## $ZOOKEEPER_HOME/cluster-zk.sh
```bash
#!/bin/bash
if [ $# = 0 ]; then
    echo "Please input commod of zkServer {start|start-foreground|stop|restart|status|upgrade|print-cmd}"
    exit 1
fi
for i in 1 2 3; do
    ssh zk-$i "echo  $i > /data/zkData/myid;$ZOOKEEPER_HOME/bin/zkServer.sh $1"
done
#tailf -500 zookeeper.out
```

## zoo.cfg
```bash
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial 
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between 
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just 
# example sakes.
dataDir=/data/zkData
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the 
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1
server.1=zk-1:2888:3888
server.2=zk-2:2888:3888
server.3=zk-3:2888:3888
```