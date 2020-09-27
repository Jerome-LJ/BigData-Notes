<nav>
<a href="#1---zookeeper-四字命令简介"</a>1 - Zookeeper 四字命令简介</a><br/>
<a href="#2---zookeeper-四字命令功能描述"</a>2 - Zookeeper 四字命令功能描述</a><br/>
<a href="#3---zookeeper-四字命令使用"</a>3 - Zookeeper 四字命令使用</a><br/>
</nav>

---

## 1 - Zookeeper 四字命令简介
Zookeeper 支持某些特定的四个字母的单词（也称为：四字命令）与其交互，用户获取 Zookeeper 服务的当前状态及相关信息，用户在客户端可以通过 telenet 或者 nc（netcat） 向 Zookeeper 提交相应的命令。

其中 `stat、srvr、cons` 三个命令比较类似："`stat`" 提供服务器统计和客户端连接的一些常规信息；"`srvr`" 提供服务器的统计信息，"`cons`" 提供客户端连接的更加详细的信息。 

**安装 nc 命令：**
```bash
$ sudo yum install nc
```

**四字命令格式如下：**
```
echo [command] | nc [ip] [port]
```

## 2 - Zookeeper 四字命令功能描述
从 3.4.10 版本开始，新增 `4lw.commands.whitelist` 功能属性。而在 3.5.3 版本中，四字命令必须在使用前明确列出白名单，否则 ZooKeeper 服务器将不会启用该命令。默认情况下，白名单仅包含 `zkServer.sh` 使用的 "`srvr`" 命令，其余四字命令被禁用。

如果要启用 stat、ruok、conf 和 isro 命令，同时禁用其余四个字母单词命令的配置示例：
```bash
#在 conf/zoo.cfg 配置文件末尾添加如下内容
4lw.commands.whitelist=stat, ruok, conf, isro
```

如果确实需要默认情况下启用所有四字命令，则可以使用 "*" 选项，这样就不必在列表中一个接一个的添加每个命令。例如，这将启用所有四字命令：
```bash
#在 conf/zoo.cfg 配置文件末尾添加如下内容
4lw.commands.whitelist=*
```

ZooKeeper 常用四字命令主要如下：

|四字命令|功能描述|
|---|---|
|conf|3.3.0 中的新增功能。输出服务相关配置的详细信息。|
|cons|3.3.0 中的新增功能。输出所有连接到该服务器的客户端完成 `连接/会话` 详细信息。包括 "`接受/发送`" 的数据包的数量、会话 ID、操作等待时间、上次的操作执行等信息。|
|crst|3.3.0 中的新增功能。重置所有连接的 `连接/会话` 统计信息。|
|dump|输出未完成的会话和临时节点。|
|envi|输出该服务器环境的详细信息。|
|reqs|3.3.2 中已废弃。列出未经处理的请求。|
|ruok|测试服务是否处于正常状态。如果确实如此，那么服务返回 `imok` 响应，否则不做任何响应。|
|srst|重置服务器统计信息。|
|srvr|3.3.0 中的新增功能。列出服务器的完整详细信息。|
|stat|输出服务器和连接的客户端的简短详细信息。|
|wchs|3.3.0 中的新增功能。输出服务器 watch 的简要信息。|
|wchc|3.3.0 中的新增功能。通过 session 输出服务器 watch 的详细信息。它的输出是一个与 watch 相关的会话的列表。**注意**，此操​​作可能会影响服务器性能，请小心使用。|
|dirs|3.5.1 中的新增功能。以字节为单位显示快照和日志文件的总大小。|
|wchp|3.3.0 中的新增功能。通过路径输出服务器 watch 的详细信息。这将输出一个与 session 相关的路径（znode）列表。**注意**，此操​​作可能会影响服务器性能，请小心使用。|
|mntr|3.4.0 中的新增功能。输出可用于检测集群健康状况的变量列表。|
|isro|3.4.0 中的新增功能。测试服务器是否以 `read-only` 模式运行。如果服务器处于只读模式，则服务器将以 `ro` 响应；如果不是只读模式，则服务器将以 `rw` 响应。|
|hash|3.6.0 中的新增功能。返回与 zxid 关联树摘要的最新历史记录。|
|gtmk|以十进制格式获取当前的跟踪掩码，作为 64 位带符号的 long 值。有关可能值的说明，请参见 stmk。|
|stmk|设置当前的跟踪掩码。跟踪掩码为 64 位，其中每个位启用或禁用服务器上特定类别的跟踪日志记录。必须先将 Log4J 配置为启用 TRACE 级别，才能查看跟踪日志记录消息。跟踪掩码的位对应于以下跟踪日志记录类别。|

> <font size=1>*注：参考官方链接：[ZooKeeper Commands](https://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_zkCommands)*</font>

## 3 - Zookeeper 四字命令使用
**1、stat 命令**

stat 命令用于获取 ZooKeeper 服务器的运行时状态信息，包括基本的 ZooKeeper 版本、打包信息、客户端的连接信息、运行时角色、集群数据节点个数等信息。
```bash
$ echo stat | nc localhost 2181
Zookeeper version: 3.5.8-f439ca583e70862c3068a1f2a7d4d068eec33315, built on 05/04/2020 15:07 GMT
Clients:
 /0:0:0:0:0:0:0:1:34808[0](queued=0,recved=1,sent=0)

Latency min/avg/max: 0/0/0
Received: 9
Sent: 7
Connections: 1
Outstanding: 0
Zxid: 0x400000000
Mode: leader
Node count: 5
Proposal sizes last/min/max: -1/-1/-1
```

**2、srvr 命令**

srvr 命令和 stat 命令的功能一致，唯一的区别是 srvr 不会将客户端的连接情况输出，仅仅输出服务器的自身信息。
```bash
$ echo srvr | nc localhost 2181
Zookeeper version: 3.5.8-f439ca583e70862c3068a1f2a7d4d068eec33315, built on 05/04/2020 15:07 GMT
Latency min/avg/max: 0/0/0
Received: 10
Sent: 8
Connections: 1
Outstanding: 0
Zxid: 0x400000000
Mode: leader
Node count: 5
Proposal sizes last/min/max: -1/-1/-1
```

**3、cons 命令**

cons 命令用于输出当前该服务器上所有客户端连接的详细信息，包括每个客户端的客户端 IP、会话 ID 和最后一次与服务器交互的操作类型等。
```bash
$ echo cons | nc localhost 2181
 /0:0:0:0:0:0:0:1:35764[0](queued=0,recved=1,sent=0)

```

**4、conf 命令**

conf 命令用于输出 ZooKeeper 服务器运行时使用的基本配置信息，包括 clientPort、dataDir 和 tickTime 等。
```bash
$ echo conf | nc localhost 2181
clientPort=2181
secureClientPort=-1
dataDir=/opt/bigdata/zookeeper-01/data/version-2
dataDirSize=67108880
dataLogDir=/opt/bigdata/zookeeper-01/logs/version-2
dataLogSize=1724
tickTime=2000
maxClientCnxns=60
minSessionTimeout=4000
maxSessionTimeout=40000
serverId=2
initLimit=5
syncLimit=2
electionAlg=3
electionPort=3888
quorumPort=2888
peerType=0
membership: 
server.1=172.16.1.11:2888:3888:participant
server.2=172.16.1.12:2888:3888:participant
server.3=172.16.1.13:2888:3888:participant
```

**5、ruok 命令**

ruok 命令用于输出当前 ZooKeeper 服务器是否正在运行。该命令的名字非常有趣，其谐音正好是 “Are you ok”。执行该命令后，如果当前 ZooKeeper 服务器正在运行，那么返回 “`imok`”，否则没有任何响应输出。
```bash
$ echo ruok |nc 127.0.0.1 2181
imok
```

**6、dump 命令**

dump 命令用于输出当前集群的所有会话信息，包括这些会话的会话 ID，以及每个会话创建的临时节点等信息。
```bash
$ echo dump |nc 127.0.0.1 2181
SessionTracker dump:
Session Sets (0)/(0):
ephemeral nodes dump:
Sessions with Ephemerals (0):
Connections dump:
Connections Sets (1)/(1):
1 expire at Sat Sep 26 00:27:30 CST 2020:
	ip: /127.0.0.1:33978 sessionId: 0x0
```

**7、dirs 命令**

dirs 命令用于以字节为单位显示快照和日志文件的总大小。
```bash
$ echo dirs |nc 127.0.0.1 2181
datadir_size: 67108880
logdir_size: 1724
```

**8、envi 命令**

envi 命令用于输出该服务器环境的详细信息。
```bash
$ echo envi |nc 127.0.0.1 2181
Environment:
zookeeper.version=3.5.8-f439ca583e70862c3068a1f2a7d4d068eec33315, built on 05/04/2020 15:07 GMT
host.name=zookeeper-01
java.version=1.8.0_261
java.vendor=Oracle Corporation
java.home=/usr/java/jdk1.8.0_261/jre
java.class.path=......
java.library.path=/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib
java.io.tmpdir=/tmp
java.compiler=<NA>
os.name=Linux
os.arch=amd64
os.version=3.10.0-1127.el7.x86_64
user.name=jerome
user.home=/home/jerome
user.dir=/opt/bigdata/zookeeper-01
os.memory.free=21MB
os.memory.max=889MB
os.memory.total=31MB
```

**9、mntr 命令**

mntr 命令用于输出比 stat 命令更为详尽的服务器统计信息，包括请求处理的延迟情况、服务器内存数据库大小和集群的数据同步情况。
```bash
$ echo mntr |nc 127.0.0.1 2181
zk_version	3.5.8-f439ca583e70862c3068a1f2a7d4d068eec33315, built on 05/04/2020 15:07 GMT
zk_avg_latency	0
zk_max_latency	0
zk_min_latency	0
zk_packets_received	17
zk_packets_sent	15
zk_num_alive_connections	1
zk_outstanding_requests	0
zk_server_state	leader
zk_znode_count	5
zk_watch_count	0
zk_ephemerals_count	0
zk_approximate_data_size	194
zk_open_file_descriptor_count	56
zk_max_file_descriptor_count	4096
zk_followers	2
zk_synced_followers	2
zk_pending_syncs	0
zk_last_proposal_size	-1
zk_max_proposal_size	-1
zk_min_proposal_size	-1
```

**10、isro 命令**

isro 命令测试该服务器是否以 `read-only` 模式运行。如果服务器处于只读模式，则服务器将以 `ro` 响应；如果不是只读模式，则服务器将以 `rw` 响应。
```bash
$ echo isro |nc 127.0.0.1 2181
rw
```
