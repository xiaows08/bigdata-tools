[TOC]
# hive安装(依赖mysql 5.7)
* 解压1.2.x
* 配置conf/hive-site.xml
```xml
<configuration>
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:mysql://10.100.63.181:3306/hive?createDatabaseIfNotExist=true</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>com.mysql.jdbc.Driver</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionUserName</name>
        <value>root</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionPassword</name>
        <value>root</value>
    </property>
</configuration>
```
* 添加mysql连接依赖 `mysql-connector-java-5.1.40.jar`

# 将hive以服务的形式运行在后台
nohub ./bin/hiveserver2 1>/dev/null 2>&1 &
## 启动后
# 客户端连接
`./bin/beeline -u jdbc:hive2://localhost:10000 -n root`

hive -e "select count(1) from default.t_test"
hive -e "create table t_count_sex(sex string, number int)"
hive -e "insert into t_count_sex select sex, count(1) from default.t_test group by sex"

-------------------------------------------
## 脚本化运行sql
vim test.hql
select * from default.t_test;

`hive -f test.hql`
## Hive的基本语法
```sql
-- 内部表
create table t_access(ip string,url string,access_time string)
row format delimited fields terminated by ','

-- 外部表[external]
create external table t_access(ip string,url string,access_time string)
row format delimited fields terminated by ','
location '/xxx/xx';

-- 删除表
drop table t_access;
    会直接删除原始hdfs目录

-- 分区表
create table t_pv_log(ip string,url string,commit_time string)
partitioned by(day string)
row format delimited fields terminated by ',';
    分区字段不能是表定义中的已存在的字段

-- 导入数据(本地导入/hdfs导入)
load data [ local ] inpath '/home/xiaows/pv.log.07' into table t_pv_log partition(day=20180907);
    本地导入 复制
    hdfs导入 移动

-- 创建一个表结构一样的表,但是没有数据
create table t_table1 like t_table2;

-- 创建一个结构一样的表,并且导入数据    
select
count(*)
from t_pv_log
where url='http://baidu.com/' and day='20180906';
```