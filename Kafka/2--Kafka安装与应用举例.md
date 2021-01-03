<nav>
<a href="#1---环境信息"</a>1 - 环境信息</a><br/>
<a href="#2---部署-jdk-环境"</a>2 - 部署 JDK 环境</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#21---下载-jdk"</a>2.1 - 下载 JDK</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#22---解压到指定目录"</a>2.2 - 解压到指定目录</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#23---配置-java-环境变量"</a>2.3 - 配置 java 环境变量</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#24---刷新配置"</a>2.4 - 刷新配置</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#25---查看版本信息"</a>2.5 - 查看版本信息</a><br/>
<a href="#3---安装部署-zookeeper-集群"</a>3 - 安装部署 ZooKeeper 集群</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#31---下载-zookeeper"</a>3.1 - 下载 ZooKeeper</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#32---解压到指定目录"</a>3.2 - 解压到指定目录</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#33---修改配置文件"</a>3.3 - 修改配置文件</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#34---启动停止查看-zookeeper-服务"</a>3.4 - 启动/停止/查看 ZooKeeper 服务</a><br/>
<a href="#4---安装部署-apache-kafka-集群"</a>4 - 安装部署 Apache Kafka 集群</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#41---下载-kafka"</a>4.1 - 下载 Kafka</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#42---解压到指定目录"</a>4.2 - 解压到指定目录</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#43---修改配置文件"</a>4.3 - 修改配置文件</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#44---启动停止-kafka-服务"</a>4.4 - 启动/停止 Kafka 服务</a><br/>
<a href="#5---入门实例"</a>5 - 入门实例</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#51---创建-kafka-topic"</a>5.1 - 创建 Kafka Topic</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#52---查看-topic-列表"</a>5.2 - 查看 Topic 列表</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#53---启动生产者以发送消息"</a>5.3 - 启动生产者以发送消息</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#54---启动消费者以接收消息"</a>5.4 - 启动消费者以接收消息</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#55---批量生产消息"</a>5.5 - 批量生产消息</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#56---其它命令使用"</a>5.6 - 其它命令使用</a><br/>
</nav>

---

## 1 - 环境信息
- 操作系统：Centos 7.8
- JDK 版本：1.8.0_261
- Kafka 版本：2.12-2.4.1

以部署集群模式为例，如果只有 1 台机器，则 Zookeeper 和 Kafka 只需部署在 1 台机器上即可。**Kafka 集群环境：**
<table>
	<tr>
	    <th>服务</th>
	    <th>节点</th>
	    <th>IP</th>  
	</tr >
	<tr >
	    <td rowspan="3">Kafka</td>
	    <td>broker-01</td>
	    <td>172.16.1.11</td>
	</tr>
	<tr>
	    <td>broker-02</td>
	    <td>172.16.1.12</td>
	</tr>
	<tr>
	    <td>broker-03</td>
	    <td>172.16.1.13</td>
	</tr>
	<tr >
	    <td rowspan="3">Zookeeper</td>
	    <td>zookeeper-01</td>
	    <td>172.16.1.11</td>
	</tr>
	<tr>
	    <td>zookeeper-02</td>
	    <td>172.16.1.12</td>
	</tr>
	<tr>
	    <td>zookeeper-03</td>
	    <td>172.16.1.13</td>
	</tr>
</table>

## 2 - 部署 JDK 环境
### 2.1 - 下载 JDK
本文以 `jdk-8u261-linux-x64.tar.gz` 为例。**每一台机器上都要部署 JDK 环境。**

官方下载地址：https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html

**Java8 Ansible Playbook 自动化安装脚本**，请点击 [传送门](./../Ansible/README.md#2---java7java8java11-自动化安装脚本)。

```bash
$ wget https://code.aliyun.com/Jerome-LJ/Software/raw/master/java/jdk-8u261-linux-x64.tar.gz
```

### 2.2 - 解压到指定目录
```bash
$ sudo mkdir /usr/java
$ sudo tar -zxf jdk-8u261-linux-x64.tar.gz -C /usr/java/
```

### 2.3 - 配置 java 环境变量
```bash
$ vim ~/.bashrc
#在文件末尾加入：
export JAVA_HOME=/usr/java/jdk1.8.0_261
export PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib:$JAVA_HOME/jre/lib
```

### 2.4 - 刷新配置
```bash
$ source ~/.bashrc
```

### 2.5 - 查看版本信息
```bash
$ java -version
java version "1.8.0_261"
Java(TM) SE Runtime Environment (build 1.8.0_261-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.261-b12, mixed mode)
```
若能正常输出以上信息，则说明 java 环境变量配置成功。

## 3 - 安装部署 ZooKeeper 集群
官方文档：https://zookeeper.apache.org/doc/r3.5.8/zookeeperStarted.html

### 3.1 - 下载 ZooKeeper
```bash
$ wget https://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.5.8/apache-zookeeper-3.5.8-bin.tar.gz
```

### 3.2 - 解压到指定目录
```bash
$ tar -zxf apache-zookeeper-3.5.8-bin.tar.gz -C /opt/bigdata && cd /opt/bigdata
$ ln -s apache-zookeeper-3.5.8-bin zookeeper
$ cd zookeeper
$ cp ./conf/zoo_sample.cfg ./conf/zoo.cfg
```

### 3.3 - 修改配置文件
```bash
$ vim ./conf/zoo.cfg
tickTime=2000
#zookeeper 保存数据的目录
dataDir=/opt/bigdata/zookeeper/data
#Zookeeper 保存日志文件目录
dataLogDir=/opt/bigdata/zookeeper/logs
#用于 Client 端连接 Zookeeper 服务
clientPort=2181
initLimit=5
syncLimit=2
#Server.1
server.1=172.16.1.11:2888:3888
#Server.2
server.2=172.16.1.12:2888:3888
#Server.3
server.3=172.16.1.13:2888:3888
leaderServes=yes
```
这个 `Server.1` 是服务器的标识，也可以是其它的数字，表示这个是第几号服务器，用来标识服务器，这个标识后续会用到。
```bash
#创建数据目录和日志目录，不建议放在同一个目录中，以减少磁盘 IO。
$ mkdir /opt/bigdata/zookeeper/{data,logs}

#Server.1 操作：
$ echo '1' > /opt/bigdata/zookeeper/data/myid

#Server.2 操作：
$ echo '2' > /opt/bigdata/zookeeper/data/myid

#Server.3 操作：
$ echo '3' > /opt/bigdata/zookeeper/data/myid
```

**Zookeeper 有三个端口：**
- 2181：用于 Client 端连接 Zookeeper 服务
- 2888：用于集群内服务互相通信（leader 和 follower）
- 3888：用于 leader 选举。

### 3.4 - 启动/停止/查看 ZooKeeper 服务
三台服务器都要启动 ZooKeeper 服务。
```bash
#启动
$ bin/zkServer.sh start
ZooKeeper JMX enabled by default
Using config: /opt/bigdata/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED

#停止
$ bin/zkServer.sh stop
ZooKeeper JMX enabled by default
Using config: /opt/bigdata/zookeeper/bin/../conf/zoo.cfg
Stopping zookeeper ... STOPPED

#查看状态
$ bin/zkServer.sh status
#或者
$ echo stat |nc localhost 2181
Zookeeper version: 3.5.8-f439ca5, built on 05/04/2020 15:07 GMT
Clients:
 /127.0.0.1:39416[0](queued=0,recved=1,sent=0)

Latency min/avg/max: 0/0/10
Received: 7490
Sent: 7489
Connections: 16
Outstanding: 0
Zxid: 0x300000000
Mode: leader
Node count: 463
```
查看 ZooKeeper 服务状态，若能正常输出以上信息，其中一台服务器模式为 `Mode: leader`，则说明 ZooKeeper 部署成功。

## 4 - 安装部署 Apache Kafka 集群
官方文档：https://kafka.apache.org/24/documentation.html

### 4.1 - 下载 Kafka
```bash
$ wget https://mirror.bit.edu.cn/apache/kafka/2.4.1/kafka_2.12-2.4.1.tgz
```

## 4.2 - 解压到指定目录
```bash
$ tar -zxf kafka_2.12-2.4.1.tgz -C /opt/bigdata && cd /opt/bigdata
$ ln -s kafka_2.12-2.4.1 kafka
$ cd kafka
```

### 4.3 - 修改配置文件
```bash
#备份 Kafka 默认配置文件
$ cp config/server.properties config/server.properties-`date +%F`
```
**broker-01 配置：**
```bash
$ cat config/server.properties
#当前机器在集群中的唯一标识
broker.id=01
#当前机器监听端口
listeners=PLAINTEXT://172.16.1.11:9092
#提供给生产者，消费者的端口号。可以不设置则使用 listeners 的值
advertised.listeners=PLAINTEXT://172.16.1.11:9092
#存储数据文件
log.dirs=/opt/bigdata/kafka/kafka-data
#连接 Zookeeper
zookeeper.connect=172.16.1.11:2181,172.16.1.12:2181,172.16.1.13:2181/kafka
```
**broker-02 配置：**
```bash
$ cat config/server.properties
#当前机器在集群中的唯一标识
broker.id=02
#当前机器监听端口
listeners=PLAINTEXT://172.16.1.12:9092
#提供给生产者，消费者的端口号。可以不设置则使用 listeners 的值
advertised.listeners=PLAINTEXT://172.16.1.12:9092
#存储数据文件
log.dirs=/opt/bigdata/kafka/kafka-data
#连接 Zookeeper
zookeeper.connect=172.16.1.11:2181,172.16.1.12:2181,172.16.1.13:2181/kafka
```
**broker-03 配置：**
```bash
$ cat config/server.properties
#当前机器在集群中的唯一标识
broker.id=03
#当前机器监听端口
listeners=PLAINTEXT://172.16.1.13:9092
#提供给生产者，消费者的端口号。可以不设置则使用 listeners 的值
advertised.listeners=PLAINTEXT://172.16.1.13:9092
#存储数据文件
log.dirs=/opt/bigdata/kafka/kafka-data
#连接 Zookeeper
zookeeper.connect=172.16.1.11:2181,172.16.1.12:2181,172.16.1.13:2181/kafka
```

### 4.4 - 启动/停止 Kafka 服务
```bash
#启动
$ bin/kafka-server-start.sh config/server.properties
#或者使用后台启动
$ bin/kafka-server-start.sh -daemon config/server.properties

#停止
$ bin/kafka-server-stop.sh config/server.properties
```

**恭喜，现在我们已经成功部署和配置了 Kafka 集群！**

## 5 - 入门实例
### 5.1 - 创建 Kafka Topic
让我们用一个分区和一个副本创建一个名为 `test` 的 Topic：
```bash
$ bin/kafka-topics.sh --create --zookeeper 172.16.1.11:2181,172.16.1.12:2181,172.16.1.13:2181/kafka --replication-factor 1 --partitions 1 --topic test
Created topic test.
```
创建 Topic 后，我们可以在 Kafka Broker 终端窗口中获取通知，并在 `config/server.properties` 文件中的 `/opt/bigdata/kafka/kafka-data` 中指定的创建 Topic 的日志。
```bash
$ ls -l /opt/bigdata/kafka/kafka-data
drwxrwxr-x 2 jerome jerome 141 Sep 17 19:02 test-0
```

### 5.2 - 查看 Topic/Consumer 列表
运行 list topic 命令，则可以看到该 Topic：
```bash
$ bin/kafka-topics.sh --zookeeper 172.16.1.11:2181,172.16.1.12:2181/kafka --list 
# 输出
test
```
由于我们已经创建了一个 Topic，它将仅列出 `test` 。假设，如果创建多个 Topic，我们将在输出中获取 Topic 名称。

运行 list group 命令，则可以看到该消费组：
```bash
$ bin/kafka-consumer-groups.sh --bootstrap-server 172.16.1.11:9092,172.16.1.12:9092 --list
# 输出
atlas
test_group
```
如果没有消费组，则没有输出。

### 5.3 - 启动生产者以生产消息
Kafka 带有一个命令行客户端，它将从文件或标准输入中获取输入，并将其作为消息发送到 Kafka 集群。默认情况下，每个新行将作为单独的新消息发送。如下所示：
```bash
$ bin/kafka-console-producer.sh --broker-list 172.16.1.11:9092,172.16.1.12:9092 --topic test
#输入一些消息
>Hello World
>This is a message
>This is another message
```

### 5.4 - 启动消费者以消费数据
与生产者类似，Kafka 还有一个命令行使用者，它将消息转储到标准输出。打开一个新终端并键入以下消息消息语法。
```bash
$ bin/kafka-console-consumer.sh --bootstrap-server 172.16.1.11:9092,172.16.1.12:9092 --topic test --from-beginning
#输出
Hello World
This is a message
This is another message
```
最后，我们可以从终端输入消息，并看到它们出现在消费者的终端中。到目前为止，已经成功了解消息生产到消费。

### 5.5 - 批量生产消息
```
$ bin/kafka-producer-perf-test.sh --topic test --num-records 1000000 --record-size 1000 --throughput 20000 --producer-props bootstrap.servers=172.16.1.11:9092,172.16.1.12:9092
```

### 5.6 - 其它命令使用
**1、修改 Topic 分区**

增加 partion 数量，从 1 个 partition 增加到 2 个：
```bash
$ bin/kafka-topics.sh --zookeeper 172.16.1.11:2181,172.16.1.12:2181/kafka --alter --topic test --partitions 2
#输出
Adding partitions succeeded!
```

**2、查看 Topic 分区详细信息**
```bash
$ bin/kafka-topics.sh --zookeeper 172.16.1.11:2181,172.16.1.12:2181/kafka --describe --topic test
#输出
Topic: test	PartitionCount: 2	ReplicationFactor: 1	Configs: 
	Topic: test	Partition: 0	Leader: 1	Replicas: 1	Isr: 1
	Topic: test	Partition: 1	Leader: 1	Replicas: 1	Isr: 1
```

**3、修改数据保存时间**
Topic 默认的数据保存 7 天。修改 test topic 数据保存 1 天（86400000 毫秒）
```bash
$ bin/kafka-topics.sh --zookeeper 172.16.1.11:2181,172.16.1.12:2181/kafka --alter --topic test --config retention.ms=86400000
#输出
Updated config for topic test.
```

**4、删除 Topic**
```bash
$ bin/kafka-topics.sh --zookeeper 172.16.1.11:2181,172.16.1.12:2181/kafka --delete --topic test
#输出
Topic test is marked for deletion.
```
**注意** - 如果在 `config/server.properties` 文件中 `delete.topic.enable` 未设置为 true，则此操作不会产生任何影响。

执行完命令后，查看 `log.dirs` 指定的目录，会发现 test 的目录都被标记为 `-delete` 结尾。

等一定的时间（根据 `log.retention.check.interval.ms` 配置而定，`hdp` 版本默认为 60s）后，被标记为 delete 的文件则会被移除。

**5、查看消费情况（Lag 堆积数）**
```bash
$ bin/kafka-consumer-groups.sh --bootstrap-server 172.16.1.11:9092,172.16.1.12:9092 --describe --group test_group
#输出
Consumer group 'test_group' has no active members.

TOPIC             PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             CONSUMER-ID     HOST            CLIENT-ID
test              0          2310            4233            1923            -               -               -
```

**6、查看 Topic 的 offset 范围**
```bash
$ bin/kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list 172.16.1.11:9092,172.16.1.12:9092 --topic test --time -1
#输出
test:0:47379
```

**7、指定 partition 和 offset 消费**
```bash
$ bin/kafka-console-consumer.sh --bootstrap-server 172.16.1.11:9092,172.16.1.12:9092 --topic test --partition 0 --offset 1024
```

**8、查看 kafla 数据 xxx.log 日志**
```bash
$ bin/kafka-run-class.sh kafka.tools.DumpLogSegments --files /data/kafka-data/logs/test-0/00000000000000000015.log --print-data-log --deep-iteration > test_topic.log
#查看 test_topic.log 输出
Starting offset: 15
...
```
