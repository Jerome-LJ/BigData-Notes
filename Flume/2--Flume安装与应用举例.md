<nav>
<a href="#1---环境信息"</a>1 - 环境信息</a><br/>
<a href="#2---安装部署-jdk"</a>2 - 安装部署 JDK</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#21---下载-jdk"</a>2.1 - 下载 JDK</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#22---解压到指定目录"</a>2.2 - 解压到指定目录</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#23---配置-java-环境变量"</a>2.3 - 配置 java 环境变量</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#24---刷新配置"</a>2.4 - 刷新配置</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#25---查看版本信息"</a>2.5 - 查看版本信息</a><br/>
<a href="#3---安装部署-flume"</a>3 - 安装部署 Flume</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#31-下载-flume"</a>3.1 下载 Flume</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#32---解压到指定目录"</a>3.2 - 解压到指定目录</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#33---修改配置文件"</a>3.3 - 修改配置文件</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#34---测试"</a>3.4 - 测试</a><br/>
<a href="#4---入门实例"</a>4 - 入门实例</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#41---编写配置文件"</a>4.1 - 编写配置文件</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#42---通过-flume-的工具启动-agent"</a>4.2 - 通过 Flume 的工具启动 Agent</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#43---发送数据"</a>4.3 - 发送数据</a><br/>
</nav>

---

## 1 - 环境信息
- 操作系统：Centos 7.8
- JDK 版本：1.8.0_261
- Flume 版本：1.9.0

## 2 - 安装部署 JDK
### 2.1 - 下载 JDK
本文以 `jdk-8u261-linux-x64.tar.gz` 为例。

官方下载地址：https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html

### 2.2 - 解压到指定目录
```bash
$ sudo mkdir /usr/java
$ sudo tar zxvf jdk-8u261-linux-x64.tar.gz -C /usr/java/
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

## 3 - 安装部署 Flume
### 3.1 下载 Flume
官方下载地址：http://flume.apache.org/download.html
```bash
$ wget http://www.apache.org/dyn/closer.lua/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz
```

### 3.2 - 解压到指定目录
```bash
#创建目录并设置权限
$ sudo mkdir /opt/bigdata && sudo chown -R $USER:$USER /opt/bigdata
#解压软件包
$ tar zxvf apache-flume-1.9.0-bin.tar.gz -C /opt/bigdata && cd /opt/bigdata
#建立软链接
$ ln -s apache-flume-1.9.0-bin flume
```

### 3.3 - 修改配置文件
```bash
$ cp ./conf/flume-env.sh.template ./conf/flume-env.sh
$ sed -i '/# export JAVA_HOME=\/usr\/lib\/jvm\/java-8-oracle/a export JAVA_HOME=\/usr\/java\/jdk1.8.0_261' ./conf/flume-env.sh
```

### 3.4 - 测试
```bash
$ ./bin/flume-ng version
Flume 1.9.0
Source code repository: https://git-wip-us.apache.org/repos/asf/flume.git
Revision: d4fcab4f501d41597bc616921329a4339f73585e
Compiled by fszabo on Mon Dec 17 20:45:25 CET 2018
From source with checksum 35db629a3bda49d23e9b3690c80737f9
```
若能正常输出以上信息，则说明 Flume 安装成功。

## 4 - 入门实例
### 4.1 - 编写配置文件
```bash
$ vim /opt/bigdata/flume/conf/example.conf
#添加以下内容：
# example.conf: A single-node Flume configuration

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

### 4.2 - 通过 Flume 的工具启动 Agent
```bash
$ bin/flume-ng agent --conf conf --conf-file conf/example.conf --name a1 -Dflume.root.logger=INFO,console

Info: Sourcing environment configuration script /opt/bigdata/flume/conf/flume-env.sh
Info: Including Hive libraries found via () for Hive access
...
...
2020-08-26 23:47:00,033 (conf-file-poller-0) [INFO - org.apache.flume.node.Application.startAllComponents(Application.java:169)] Starting Channel c1
2020-08-26 23:47:00,034 (conf-file-poller-0) [INFO - org.apache.flume.node.Application.startAllComponents(Application.java:184)] Waiting for channel: c1 to start. Sleeping for 500 ms
2020-08-26 23:47:00,175 (lifecycleSupervisor-1-0) [INFO - org.apache.flume.instrumentation.MonitoredCounterGroup.register(MonitoredCounterGroup.java:119)] Monitored counter group for type: CHANNEL, name: c1: Successfully registered new MBean.
2020-08-26 23:47:00,175 (lifecycleSupervisor-1-0) [INFO - org.apache.flume.instrumentation.MonitoredCounterGroup.start(MonitoredCounterGroup.java:95)] Component type: CHANNEL, name: c1 started
2020-08-26 23:47:00,534 (conf-file-poller-0) [INFO - org.apache.flume.node.Application.startAllComponents(Application.java:196)] Starting Sink k1
2020-08-26 23:47:00,536 (conf-file-poller-0) [INFO - org.apache.flume.node.Application.startAllComponents(Application.java:207)] Starting Source r1
2020-08-26 23:47:00,537 (lifecycleSupervisor-1-2) [INFO - org.apache.flume.source.NetcatSource.start(NetcatSource.java:155)] Source starting
2020-08-26 23:47:00,892 (lifecycleSupervisor-1-2) [INFO - org.apache.flume.source.NetcatSource.start(NetcatSource.java:166)] Created serverSocket:sun.nio.ch.ServerSocketChannelImpl[/127.0.0.1:44444]
```
若能正常输出以上信息，则说明 Agent 启动成功。

### 4.3 - 发送数据
然后，我们可以从另一个终端通过 telnet 端口 44444 发送 Flume 事件
```bash
$ telnet localhost 44444
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
Hello world! <ENTER>
OK
```

原来的 Flume 终端将在日志消息中输出事件。
```bash
2020-08-26 23:47:00,892 (lifecycleSupervisor-1-2) [INFO - org.apache.flume.source.NetcatSource.start(NetcatSource.java:166)] Created serverSocket:sun.nio.ch.ServerSocketChannelImpl[/127.0.0.1:44444]
2020-08-26 23:49:08,817 (SinkRunner-PollingRunner-DefaultSinkProcessor) [INFO - org.apache.flume.sink.LoggerSink.process(LoggerSink.java:95)] Event: { headers:{} body: 48 65 6C 6C 6F 20 77 6F 72 6C 64 21 0D          Hello world!. }
```

恭喜，现在我们已经成功部署和配置了 Flume 代理！ 更详细的代理配置[参考官网](http://flume.apache.org/releases/content/1.9.0/FlumeUserGuide.html#using-environment-variables-in-configuration-files)。
