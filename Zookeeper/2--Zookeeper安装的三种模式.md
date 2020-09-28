<nav>
<a href="#1---环境信息"</a>1 - 环境信息</a><br/>
<a href="#2---部署-jdk-环境"</a>2 - 部署 JDK 环境</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#21---下载-jdk"</a>2.1 - 下载 JDK</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#22---解压到指定目录"</a>2.2 - 解压到指定目录</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#23---配置-java-环境变量"</a>2.3 - 配置 java 环境变量</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#24---刷新配置"</a>2.4 - 刷新配置</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#25---查看版本信息"</a>2.5 - 查看版本信息</a><br/>
<a href="#3---单机模式"</a>3 - 单机模式</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#31---下载-zookeeper"</a>3.1 - 下载 ZooKeeper</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#32---解压到指定目录"</a>3.2 - 解压到指定目录</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#33---修改配置文件"</a>3.3 - 修改配置文件</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#34---启动停止查看-zookeeper-服务"</a>3.4 - 启动/停止/查看 ZooKeeper 服务</a><br/>
<a href="#4---伪集群模式"</a>4 - 伪集群模式</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#41---下载-zookeeper"</a>4.1 - 下载 ZooKeeper</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#42---解压到指定目录"</a>4.2 - 解压到指定目录</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#43---修改配置文件"</a>4.3 - 修改配置文件</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#44---启动停止查看-zookeeper-服务"</a>4.4 - 启动/停止/查看 ZooKeeper 服务</a><br/>
<a href="#5---集群模式"</a>5 - 集群模式</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#51---下载-zookeeper"</a>5.1 - 下载 ZooKeeper</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#52---解压到指定目录"</a>5.2 - 解压到指定目录</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#53---修改配置文件"</a>5.3 - 修改配置文件</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#54---启动停止查看-zookeeper-服务"</a>5.4 - 启动/停止/查看 ZooKeeper 服务</a><br/>
<a href="#6---常见问题处理"</a>6 - 常见问题处理</a><br/>
</nav>

---

## 1 - 环境信息
- 操作系统：Centos 7.8
- JDK 版本：1.8.0_261
- Zookeeper 版本：3.5.8

Zookeeper 的安装分为三种模式：**单机模式、伪集群模式和集群模式**。

<table>
	<tr>
	    <th>模式</th>
	    <th>节点</th>
	    <th>IP</th>  
	</tr >
	<tr>
        <td>单机模式</td>
	    <td>zookeeper</td>
	    <td>172.16.1.8</td>
	</tr>
	<tr>
        <td>伪集群模式</td>
	    <td>zookeeper</td>
	    <td>172.16.1.9</td>
	</tr>
	<tr >
	    <td rowspan="3">集群模式</td>
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

JAVA8 Ansible Playbook 自动化安装脚本，请点击 [传送门](./../Ansible/README.md#1---java7java8/java11-自动化安装脚本)。

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

## 3 - 单机模式
一台服务器只部署一个 Zookeeper 节点，参考[官方文档](https://zookeeper.apache.org/doc/r3.5.8/zookeeperStarted.html)。

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
server.1=172.16.1.8:2888:3888
leaderServes=yes
```
这个 `Server.1` 是服务器的标识，也可以是其它的数字， 表示这个是第几号服务器，用来标识服务器，这个标识后续会用到。
```bash
#创建数据目录和日志目录，不建议放在同一个目录中，以减少磁盘 IO。
$ mkdir /opt/bigdata/zookeeper/{data,logs}

#Server.1 操作：
$ echo '1' > /opt/bigdata/zookeeper/data/myid
```

**Zookeeper 有三个端口：**
- 2181：用于 Client 端连接 Zookeeper 服务
- 2888：用于集群内服务互相通信（leader 和 follower）
- 3888：用于 leader 选举。

### 3.4 - 启动/停止/查看 ZooKeeper 服务
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
ZooKeeper JMX enabled by default
Using config: /opt/bigdata/zookeeper/bin/../conf/zoo.cfg
Client port found: 2181. Client address: localhost.
Mode: standalone

#或者
$ echo stat |nc localhost 2181
Zookeeper version: 3.5.8-f439ca583e70862c3068a1f2a7d4d068eec33315, built on 05/04/2020 15:07 GMT
Clients:
 /0:0:0:0:0:0:0:1:39882[0](queued=0,recved=1,sent=0)

Latency min/avg/max: 0/0/0
Received: 2
Sent: 1
Connections: 1
Outstanding: 0
Zxid: 0x100000000
Mode: standalone
Node count: 5
```
查看 ZooKeeper 服务状态，若能正常输出以上信息，服务器模式为 `Mode: standalone`，则说明 ZooKeeper 部署成功。

通过客户端命令 `zkCli.sh `，进入命令行工具。
```bash
$ bin/zkCli.sh -server 127.0.0.1:2181
```

## 4 - 伪集群模式
一台服务器部署三个 Zookeeper 节点，参考[官方文档](https://zookeeper.apache.org/doc/r3.5.8/zookeeperStarted.html)。

### 4.1 - 下载 ZooKeeper
```bash
$ wget https://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.5.8/apache-zookeeper-3.5.8-bin.tar.gz
```

### 4.2 - 解压到指定目录
```bash
$ tar -zxf apache-zookeeper-3.5.8-bin.tar.gz -C /opt/bigdata && cd /opt/bigdata
$ cp -r apache-zookeeper-3.5.8-bin zookeeper-01
$ cp -r apache-zookeeper-3.5.8-bin zookeeper-02
$ mv apache-zookeeper-3.5.8-bin zookeeper-03
$ ls -l .
drwxrwxr-x 8 jerome jerome      158 Sep 27 10:30 zookeeper-01
drwxrwxr-x 8 jerome jerome      158 Sep 27 10:30 zookeeper-02
drwxrwxr-x 8 jerome jerome      158 Sep 27 10:30 zookeeper-03
```

### 4.3 - 修改配置文件
**1、进入到 zookeeper-01 目录操作：**
```bash
$ cd zookeeper-01
$ cp ./conf/zoo_sample.cfg ./conf/zoo.cfg
$ vim ./conf/zoo.cfg
tickTime=2000
#zookeeper 保存数据的目录
dataDir=/opt/bigdata/zookeeper-01/data
#Zookeeper 保存日志文件目录
dataLogDir=/opt/bigdata/zookeeper-01/logs
#用于 Client 端连接 Zookeeper 服务（注意端口：2181）
clientPort=2181
initLimit=5
syncLimit=2
server.1=172.16.1.9:2888:3888
server.2=172.16.1.9:2889:3889
server.3=172.16.1.9:2890:3890
leaderServes=yes
```
这个 `Server.1` 是服务器的标识，也可以是其它的数字，表示这个是第几号服务器，用来标识服务器，这个标识后续会用到。
```bash
#创建数据目录和日志目录，不建议放在同一个目录中，以减少磁盘 IO。
$ mkdir /opt/bigdata/zookeeper-01/{data,logs}

#Server.1 操作：
$ echo '1' > /opt/bigdata/zookeeper-01/data/myid
```

**2、进入到 zookeeper-02 目录操作：**
```bash
$ cd zookeeper-02
$ cp ./conf/zoo_sample.cfg ./conf/zoo.cfg
$ vim ./conf/zoo.cfg
tickTime=2000
#zookeeper 保存数据的目录
dataDir=/opt/bigdata/zookeeper-02/data
#Zookeeper 保存日志文件目录
dataLogDir=/opt/bigdata/zookeeper-02/logs
#用于 Client 端连接 Zookeeper 服务（注意端口：2182）
clientPort=2182
initLimit=5
syncLimit=2
server.1=172.16.1.9:2888:3888
server.2=172.16.1.9:2889:3889
server.3=172.16.1.9:2890:3890
leaderServes=yes
```
这个 `Server.2` 是服务器的标识，也可以是其它的数字，表示这个是第几号服务器，用来标识服务器，这个标识后续会用到。
```bash
#创建数据目录和日志目录，不建议放在同一个目录中，以减少磁盘 IO。
$ mkdir /opt/bigdata/zookeeper-02/{data,logs}

#Server.2 操作：
$ echo '2' > /opt/bigdata/zookeeper-02/data/myid
```

**3、进入到 zookeeper-03 目录操作：**
```bash
$ cd zookeeper-03
$ cp ./conf/zoo_sample.cfg ./conf/zoo.cfg
$ vim ./conf/zoo.cfg
tickTime=2000
#zookeeper 保存数据的目录
dataDir=/opt/bigdata/zookeeper-03/data
#Zookeeper 保存日志文件目录
dataLogDir=/opt/bigdata/zookeeper-03/logs
#用于 Client 端连接 Zookeeper 服务（注意端口：2183）
clientPort=2183
initLimit=5
syncLimit=2
server.1=172.16.1.9:2888:3888
server.2=172.16.1.9:2889:3889
server.3=172.16.1.9:2890:3890
leaderServes=yes
```
这个 `Server.3` 是服务器的标识，也可以是其它的数字，表示这个是第几号服务器，用来标识服务器，这个标识后续会用到。
```bash
#创建数据目录和日志目录，不建议放在同一个目录中，以减少磁盘 IO。
$ mkdir /opt/bigdata/zookeeper-03/{data,logs}

#Server.3 操作：
$ echo '3' > /opt/bigdata/zookeeper-03/data/myid
```

**Zookeeper 有三个端口：**
- 2181：用于 Client 端连接 Zookeeper 服务
- 2888：用于集群内服务互相通信（leader 和 follower）
- 3888：用于 leader 选举。

### 4.4 - 启动/停止/查看 ZooKeeper 服务
**三台服务器都要启动 ZooKeeper 服务。**
```bash
#启动
$ bin/zkServer.sh start
ZooKeeper JMX enabled by default
Using config: /opt/bigdata/zookeeper-01/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED

#停止
$ bin/zkServer.sh stop
ZooKeeper JMX enabled by default
Using config: /opt/bigdata/zookeeper-01/bin/../conf/zoo.cfg
Stopping zookeeper ... STOPPED

#查看状态
$ bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /opt/bigdata/zookeeper-01/bin/../conf/zoo.cfg
Client port found: 2181. Client address: localhost.
Mode: leader

#或者
$ echo stat |nc localhost 2181
Zookeeper version: 3.5.8-f439ca583e70862c3068a1f2a7d4d068eec33315, built on 05/04/2020 15:07 GMT
Clients:
 /0:0:0:0:0:0:0:1:50448[0](queued=0,recved=1,sent=0)

Latency min/avg/max: 0/0/0
Received: 2
Sent: 1
Connections: 1
Outstanding: 0
Zxid: 0x200000001
Mode: leader
Node count: 5
Proposal sizes last/min/max: 32/32/32
```
查看 ZooKeeper 服务状态，若能正常输出以上信息，其中一台服务器模式为 `Mode: leader`，则说明 ZooKeeper 部署成功。

通过客户端命令 `zkCli.sh `，进入命令行工具。
```bash
$ bin/zkCli.sh -server 127.0.0.1:2181
```

## 5 - 集群模式
三台服务器部署三个 Zookeeper 节点，参考[官方文档](https://zookeeper.apache.org/doc/r3.5.8/zookeeperStarted.html)。

### 5.1 - 下载 ZooKeeper
每一台服务器都要下载 ZooKeeper 安装包。
```bash
#zookeeper-01（172.16.1.11）操作：
$ wget https://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.5.8/apache-zookeeper-3.5.8-bin.tar.gz

#zookeeper-02（172.16.1.12）操作：
$ wget https://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.5.8/apache-zookeeper-3.5.8-bin.tar.gz

#zookeeper-03（172.16.1.13）操作：
$ wget https://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.5.8/apache-zookeeper-3.5.8-bin.tar.gz
```

### 5.2 - 解压到指定目录
每一台服务器都要下载 ZooKeeper 安装包。
```bash
#zookeeper-01（172.16.1.11）操作：
$ tar -zxf apache-zookeeper-3.5.8-bin.tar.gz -C /opt/bigdata && cd /opt/bigdata
$ ln -s apache-zookeeper-3.5.8-bin zookeeper
$ cd zookeeper
$ cp ./conf/zoo_sample.cfg ./conf/zoo.cfg

#zookeeper-02（172.16.1.12）操作：
$ tar -zxf apache-zookeeper-3.5.8-bin.tar.gz -C /opt/bigdata && cd /opt/bigdata
$ ln -s apache-zookeeper-3.5.8-bin zookeeper
$ cd zookeeper
$ cp ./conf/zoo_sample.cfg ./conf/zoo.cfg

#zookeeper-03（172.16.1.13）操作：
$ tar -zxf apache-zookeeper-3.5.8-bin.tar.gz -C /opt/bigdata && cd /opt/bigdata
$ ln -s apache-zookeeper-3.5.8-bin zookeeper
$ cd zookeeper
$ cp ./conf/zoo_sample.cfg ./conf/zoo.cfg
```

### 5.3 - 修改配置文件
**1、进入到 zookeeper-01（172.16.1.11）目录操作：**
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
server.1=172.16.1.11:2888:3888
server.2=172.16.1.12:2888:3888
server.3=172.16.1.13:2888:3888
leaderServes=yes
```
这个 `Server.1` 是服务器的标识，也可以是其它的数字，表示这个是第几号服务器，用来标识服务器，这个标识后续会用到。
```bash
#创建数据目录和日志目录，不建议放在同一个目录中，以减少磁盘 IO。
$ mkdir /opt/bigdata/zookeeper/{data,logs}

#Server.1 操作：
$ echo '1' > /opt/bigdata/zookeeper/data/myid
```

**2、进入到 zookeeper-02（172.16.1.12）目录操作：**
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
server.1=172.16.1.11:2888:3888
server.2=172.16.1.12:2888:3888
server.3=172.16.1.13:2888:3888
leaderServes=yes
```
这个 `Server.2` 是服务器的标识，也可以是其它的数字，表示这个是第几号服务器，用来标识服务器，这个标识后续会用到。
```bash
#创建数据目录和日志目录，不建议放在同一个目录中，以减少磁盘 IO。
$ mkdir /opt/bigdata/zookeeper/{data,logs}

#Server.2 操作：
$ echo '2' > /opt/bigdata/zookeeper/data/myid
```

**3、进入到 zookeeper-03（172.16.1.13）目录操作：**
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
server.1=172.16.1.11:2888:3888
server.2=172.16.1.12:2888:3888
server.3=172.16.1.13:2888:3888
leaderServes=yes
```
这个 `Server.3` 是服务器的标识，也可以是其它的数字，表示这个是第几号服务器，用来标识服务器，这个标识后续会用到。
```bash
#创建数据目录和日志目录，不建议放在同一个目录中，以减少磁盘 IO。
$ mkdir /opt/bigdata/zookeeper/{data,logs}

#Server.3 操作：
$ echo '3' > /opt/bigdata/zookeeper/data/myid
```

**Zookeeper 有三个端口：**
- 2181：用于 Client 端连接 Zookeeper 服务
- 2888：用于集群内服务互相通信（leader 和 follower）
- 3888：用于 leader 选举。

### 5.4 - 启动/停止/查看 ZooKeeper 服务
**三台服务器都要启动 ZooKeeper 服务。**
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
ZooKeeper JMX enabled by default
Using config: /opt/bigdata/zookeeper/bin/../conf/zoo.cfg
Client port found: 2181. Client address: localhost.
Mode: leader

#或者
$ echo stat |nc localhost 2181
Zookeeper version: 3.5.8-f439ca583e70862c3068a1f2a7d4d068eec33315, built on 05/04/2020 15:07 GMT
Clients:
 /0:0:0:0:0:0:0:1:55082[0](queued=0,recved=1,sent=0)

Latency min/avg/max: 0/0/0
Received: 4
Sent: 3
Connections: 1
Outstanding: 0
Zxid: 0x200000001
Mode: leader
Node count: 5
Proposal sizes last/min/max: 32/32/32
```
查看 ZooKeeper 服务状态，若能正常输出以上信息，其中一台服务器模式为 `Mode: leader`，则说明 ZooKeeper 部署成功。

通过客户端命令 `zkCli.sh `，进入命令行工具。
```bash
$ bin/zkCli.sh -server 127.0.0.1:2181
```

## 6 - 常见问题处理
**1、启动 Zookeeper 提示有 WARN 信息**
产生下面两条 `WARN` 信息是因为 Zookeeper 服务的每个实例都拥有全局的配置信息，他们在启动的时候需要随时随地的进行 leader 选举，此时 `server.1` 就需要和其它两个 Zookeeper 实例进行通信，但是，另外两个 Zookeeper 实例还没有启动起来，因此将会产生下面所示的提示信息。当我们用同样的方式启动 `server.2` 和 `server.3` 后就不会再有这样的警告信息了。
```bash
$ tail -f logs/zookeeper-jerome-zookeeper-01.out
2020-09-27 11:22:03,338 [myid:1] - WARN  [QuorumConnectionThread-[myid=1]-4:QuorumCnxManager@381] - Cannot open channel to 3 at election address /172.16.1.12:3888
java.net.ConnectException: Connection refused (Connection refused)
	at java.net.PlainSocketImpl.socketConnect(Native Method)
	at java.net.AbstractPlainSocketImpl.doConnect(AbstractPlainSocketImpl.java:476)
	at java.net.AbstractPlainSocketImpl.connectToAddress(AbstractPlainSocketImpl.java:218)
	at java.net.AbstractPlainSocketImpl.connect(AbstractPlainSocketImpl.java:200)
	at java.net.SocksSocketImpl.connect(SocksSocketImpl.java:394)
	at java.net.Socket.connect(Socket.java:606)
	at org.apache.zookeeper.server.quorum.QuorumCnxManager.initiateConnection(QuorumCnxManager.java:373)
	at org.apache.zookeeper.server.quorum.QuorumCnxManager$QuorumConnectionReqThread.run(QuorumCnxManager.java:436)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
	at java.lang.Thread.run(Thread.java:748)
2020-09-27 11:22:03,456 [myid:1] - WARN  [QuorumConnectionThread-[myid=1]-4:QuorumCnxManager@381] - Cannot open channel to 3 at election address /172.16.1.13:3888
java.net.ConnectException: Connection refused (Connection refused)
	at java.net.PlainSocketImpl.socketConnect(Native Method)
	at java.net.AbstractPlainSocketImpl.doConnect(AbstractPlainSocketImpl.java:476)
	at java.net.AbstractPlainSocketImpl.connectToAddress(AbstractPlainSocketImpl.java:218)
	at java.net.AbstractPlainSocketImpl.connect(AbstractPlainSocketImpl.java:200)
	at java.net.SocksSocketImpl.connect(SocksSocketImpl.java:394)
	at java.net.Socket.connect(Socket.java:606)
	at org.apache.zookeeper.server.quorum.QuorumCnxManager.initiateConnection(QuorumCnxManager.java:373)
	at org.apache.zookeeper.server.quorum.QuorumCnxManager$QuorumConnectionReqThread.run(QuorumCnxManager.java:436)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
	at java.lang.Thread.run(Thread.java:748)
```

**2、四字命令不在 Zookeeper 的白名单里**

使用四字命令时出现下面这个提示，说明该命令不在zookeeper的白名单里。
```bash
$ echo stat |nc localhost 2181
stat is not executed because it is not in the whitelist.
```

**解决步骤：**
- 1）在 `zoo.cfg` 配置文件中加入 `4lw.commands.whitelist=*`，表示将四字命令加入到白名单中。配置如下：
```bash
tickTime=2000
dataDir=/opt/bigdata/zookeeper/data
dataLogDir=/opt/bigdata/zookeeper/logs
clientPort=2181
initLimit=5
syncLimit=2
server.1=172.16.1.11:2888:3888
server.2=172.16.1.12:2888:3888
server.3=172.16.1.13:2888:3888
leaderServes=yes

#添加参数
4lw.commands.whitelist=*
```
- 2）重启 Zookeeper 服务
```bash
$ bin/zkServer.sh restart
```
