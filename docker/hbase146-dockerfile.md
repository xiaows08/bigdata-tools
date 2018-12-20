[TOC]
## Dockerfile-hbase146
```docker
#hbase146-jdk.dockerfile

#|-- hbase146-jdk.dockerfile
#`-- hbase-1.4.6
#    |-- CHANGES.txt
#    |-- LEGAL
#    |-- LICENSE.txt
#    |-- NOTICE.txt
#    |-- README.txt
#    |-- bin
#    |-- conf
#    |-- hbase-webapps
#    |-- lib
#    `-- logs

FROM xiaows/debian8-jdk8-ssh:3.0

# TODO download & decompression & modify conf/{hbase-env.sh,hbase-site.xml,regionservers}
## wget http://archive.apache.org/dist/hbase/1.4.6/hbase-1.4.6-bin.tar.gz
ADD hbase-1.4.6/ /usr/local/hbase-1.4.6/

ENV HBASE_HOME=/usr/local/hbase-1.4.6/
ENV PAHT=$PATH:HBASE_HOME/bin

WORKDIR $HBASE_HOME

COPY hbase146-jdk.dockerfile /
```

## $HBASE_HOME/conf/hbase-env.sh
```bash
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HBASE_MANAGES_ZK=false
```

## $HBASE_HOME/conf/hbase-site.xml
```xml
<configuration>
    <property>
        <name>hbase.cluster.distributed</name>
        <value>true</value>
    </property>
    <property>
        <name>hbase.rootdir</name>
        <value>hdfs://hadoop-1:9000/hbase</value>
    </property>
    <property>
        <name>hbase.zookeeper.quorum</name>
        <value>zk-1:2181,zk-2:2181,zk-3:2181</value>
    </property>
</configuration>
```

## $HBASE_HOME/conf/regionservers
```bash
hbase-1
hbase-2
hbase-3
```

*启动HBASE集群
`./bin/start-hbase.sh`
