[TOC]
## flume180.dockerfile
```docker
# Dockerfile-kafka211-jdk
# .
# ├── apache-flume-1.8.0-bin
# │   ├── CHANGELOG
# │   ├── DEVNOTES
# │   ├── LICENSE
# │   ├── NOTICE
# │   ├── README.md
# │   ├── RELEASE-NOTES
# │   ├── bin
# │   ├── conf
# │   ├── doap_Flume.rdf
# │   ├── lib
# │   └── tools
# └── flume180.dockerfile

FROM xiaows/debian8-jdk8-ssh:3.2

## wget http://mirrors.tuna.tsinghua.edu.cn/apache/flume/1.8.0/apache-flume-1.8.0-bin.tar.gz
ADD apache-flume-1.8.0-bin/ /usr/local/flume-1.8.0-bin/

ENV FLUME_HOME=/usr/local/flume-1.8.0-bin/
ENV PAHT=$PATH:$FLUME_HOME/bin

WORKDIR $FLUME_HOME

COPY flume180.dockerfile /
```

## $FLUME_HOME/conf/netcat-r_memory-c_logger-k.conf
```properties
# Name the components on this agent
a1.sources = r1
a1.sinks = k1
a1.channels = c1

# Describe/configure the source
a1.sources.r1.type = netcat
a1.sources.r1.bind = localhost
a1.sources.r1.port = 44444

# Describe the sink
a1.sinks.k1.type = logger

# Use a channel which buffers events in memory
a1.channels.c1.type = memory
a1.channels.c1.capacity = 1000
a1.channels.c1.transactionCapacity = 100

# Bind the source and sink to the channel
a1.sources.r1.channels = c1
a1.sinks.k1.channel = c1
```

## $FLUME_HOME/conf/kafka-c_hdfs-k.conf
```properties
# kafka Channel + HDFS sink(without sources)
a1.channels = c1
a1.sinks = k1

# 定义 KafkaChannel
a1.channels.c1.type = org.apache.flume.channel.kafka.KafkaChannel
a1.channels.c1.parseAsFlumeEvent = false
a1.channels.c1.kafka.bootstrap.servers = kafka-1:9092,kafka-2:9092,kafka-3:9092
a1.channels.c1.kafka.topic = user
a1.channels.c1.kafka.consumer.group.id = g1

# 定义 HDFS sink
a1.sinks.k1.channel = c1
a1.sinks.k1.type = hdfs
a1.sinks.k1.hdfs.path = hdfs://hadoop-1:9000/flume/%Y%m%d/%H
a1.sinks.k1.hdfs.useLocalTimeStamp = true
a1.sinks.k1.hdfs.filePrefix = log
a1.sinks.k1.hdfs.fileType = DataStream
# 不按照条数生成文件
a1.sinks.k1.hdfs.rollCount = 0
# HDFS 上的文件达到128M 生成一个文件
a1.sinks.k1.hdfs.rollSize = 134217728
# HDFS 上的文件达到10分钟生成一个文件
a1.sinks.k1.hdfs.rollInterval = 600
```
**记得配 hosts**
   
- <u>**添加 HDFS 相关jar包和配置文件**</u>
```
commons-configuration-1.6.jar
commons-io-2.4.jar
hadoop-auth-2.8.3.jar
hadoop-common-2.8.3.jar
hadoop-hdfs-2.8.3.jar
hadoop-hdfs-client-2.8.3.jar
htrace-core4-4.0.1-incubating.jar
core-site.xml
hdfs-site.xml
```

- flume-1.8 kafka客户端默认版本0.9 但是向上兼容(别用这个 有巨坑!!!)
~~`kafka-clients-2.0.0.jar kafka_2.11-2.0.0.jar`~~

- 先启动 zookeeper kafka 和 HDFS(否则会各种报错,)

- 进入`$FLUME_HOME`启动 flume
`root@common:/usr/local/flume# ./bin/flume-ng agent -c conf/ -f conf/kafka-hdfs.conf -n a1 -Dflume.root.logger=INFO,console`