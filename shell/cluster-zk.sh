#!/bin/bash
if [ $# = 0 ]; then
    echo "Please input commod of zkServer {start|start-foreground|stop|restart|status|upgrade|print-cmd"
    exit 1
fi
for host in zk-1 zk-2 zk-3
do
	echo "${host}: ${1}ing......"
    ssh $host "source /etc/profile;/root/zookeeper/bin/zkServer.sh $1"
done

sleep 2

for host in zk-1 zk-2 zk-3
do
    ssh $host "source /etc/profile;/root/zookeeper/bin/zkServer.sh status"
done
