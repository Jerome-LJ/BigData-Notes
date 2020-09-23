[![GitHub stars](https://img.shields.io/github/stars/Jerome-LJ/BigData-Notes.svg?style=social&label=Stars)](https://github.com/Jerome-LJ/BigData-Notes/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/Jerome-LJ/BigData-Notes.svg?style=social&label=Fork)](https://github.com/Jerome-LJ/BigData-Notes/network/members)
[![GitHub watchers](https://img.shields.io/github/watchers/Jerome-LJ/BigData-Notes.svg?style=social&label=Watch)](https://github.com/Jerome-LJ/BigData-Notes/watchers)
[![GitHub followers](https://img.shields.io/github/followers/Jerome-LJ.svg?style=social&label=Follow)](https://github.com/Jerome-LJ?tab=following)

[![GitHub issues](https://img.shields.io/github/issues/Jerome-LJ/BigData-Notes.svg)](https://github.com/Jerome-LJ/BigData-Notes/issues)
[![GitHub last commit](https://img.shields.io/github/last-commit/Jerome-LJ/BigData-Notes.svg)](https://github.com/Jerome-LJ/BigData-Notes/commits)
[![GitHub repo size in bytes](https://img.shields.io/github/repo-size/Jerome-LJ/BigData-Notes.svg)](https://github.com/Jerome-LJ/BigData-Notes)
[![HitCount](https://hits.b3log.org/Jerome-LJ/BigData-Notes.svg)](https://github.com/Jerome-LJ/BigData-Notes)

---

# BigData-Notes
Hadoop 生态圈，大数据学习之路。仅作为学习笔记供个人和交流使用，不用作商业用途。文中有按自己思路摘抄和引用的内容，如涉及版权请与我联系。欢迎交流，共同学习！

<table>
    <tr>
      <th><img width="70px" src="images/logo/hadoop.logo.png"></th>
      <th><img width="70px" src="images/logo/spark-logo.png"></th>
      <th><img width="70px" src="images/logo/hbase-logo.png"></th>
      <th><img width="70px" src="images/logo/kudu-logo.png"></th>
      <th><img width="70px" src="images/logo/hive-logo.png"></th>
      <th><img width="70px" src="images/logo/presto-logo.png"></th>
      <th><img width="70px" src="images/logo/flume-logo.png"></th>
      <th><img width="70px" src="images/logo/kafka-logo.png"></th>
      <th><img width="70px" src="images/logo/zookeeper-logo.png"></th>
      <th><img width="70px" src="images/logo/cloudera-logo.jpg"></th>
    </tr>
    <tr>
      <td align="center"><a href="#一hadoop分布式系统基础架构">Hadoop</a></td>
      <td align="center"><a href="#二spark分布式计算引擎">Spark</a></td>
      <td align="center"><a href="#三hbase分布式列存储数据库">HBase</a></td>
      <td align="center"><a href="#四kudu列式存储管理器">Kudu</a></td>
      <td align="center"><a href="#五hive数据仓库工具">Hive</a></td>
      <td align="center"><a href="#六presto分布式sql查询引擎">Presto</a></td>
      <td align="center"><a href="#七flume日志收集工具">Flume</a></td>
      <td align="center"><a href="#八kafka分布式消息队列">Kafka</a></td>
      <td align="center"><a href="#九zookeeper分布式协调服务">ZooKeeper</a></td>
      <td align="center"><a href="#十cloudera-manager大数据运维工具">Cloudera</a></td>
    </tr>
    <tr>
      <th><img width="70px" src="images/logo/azkaban-logo.png"></th>
      <th><img width="70px" src="images/logo/elastic-logo.png"></th>
      <th><img width="70px" src="images/logo/docker.png"></th>
      <th><img width="70px" src="images/logo/kubernetes-logo.png"></th>
    </tr>
    <tr>
      <td align="center"><a href="#十一azkaban批处理工作流调度器">Azkaban</a></td>
      <td align="center"><a href="#十二elastic分布式搜索和分析引擎">Elastic</a></td>
      <td align="center"><a href="#十三docker应用容器引擎">Docker</a></td>
      <td align="center"><a href="#十四kubernetes容器集群管理系统">Kubernetes</a></td>
    </tr>
  </table>
<br/>

---

## 一、Hadoop（分布式系统基础架构）
&emsp;&emsp;&emsp;&emsp;[1 - HDFS 入门指南（Hadoop 分布式文件系统）](./Hadoop/1--HDFS入门指南--Hadoop分布式文件系统.md)<br/>
&emsp;&emsp;&emsp;&emsp;[2 - MapReduce 入门指南（分布式计算框架）](./Hadoop/2--MapReduce入门指南--分布式计算框架.md)<br/>
&emsp;&emsp;&emsp;&emsp;[3 - Yarn 入门指南（集群资源管理系统）](./Hadoop/3--Yarn入门指南--集群资源管理系统.md)<br/>
&emsp;&emsp;&emsp;&emsp;[4 - 从生日请客到 HDFS 工作原理解析](./Hadoop/4--从生日请客到HDFS工作原理解析.md)<br/>
&emsp;&emsp;&emsp;&emsp;[5 - 从打牌到 Map-Reduce 工作原理解析](./Hadoop/5--从打牌到Map-Reduce工作原理解析.md)
## 二、Spark（分布式计算引擎）
&emsp;&emsp;&emsp;&emsp;[1 - Spark 入门指南](./Spark/1--Spark入门指南.md)
## 三、HBase（分布式列存储数据库）
&emsp;&emsp;&emsp;&emsp;[1 - HBase 入门指南](./HBase/1--HBase入门指南.md)<br/>
&emsp;&emsp;&emsp;&emsp;[2 - HBase 架构及各角色功能](./HBase/2--HBase架构及各角色功能.md)<br/>
&emsp;&emsp;&emsp;&emsp;[3 - 从洗袜子到 HBase 存储原理解析](./HBase/3--从洗袜子到HBase存储原理解析.md)<br/>
## 四、Kudu（列式存储管理器）
&emsp;&emsp;&emsp;&emsp;[1 - Kudu 入门指南](./Kudu/1--Kudu入门指南.md)
## 五、Hive（数据仓库工具）
&emsp;&emsp;&emsp;&emsp;[1 - Hive 入门指南](./Hive/1--Hive门指南.md)<br/>
&emsp;&emsp;&emsp;&emsp;[2 - 从电影字幕到 Hive 工作原理解析](./Hive/2--从电影字幕到Hive工作原理解析.md)
## 六、Presto（分布式SQL查询引擎）
&emsp;&emsp;&emsp;&emsp;[1 - Presto 入门指南](./Presto/1--Presto入门指南.md)
## 七、Flume（日志收集工具）
&emsp;&emsp;&emsp;&emsp;[1 - Flume 入门指南](./Flume/1--Flume入门指南.md)<br/>
&emsp;&emsp;&emsp;&emsp;[2 - Flume 安装与应用举例](./Flume/2--Flume安装与应用举例.md)
## 八、Kafka（分布式消息队列）
&emsp;&emsp;&emsp;&emsp;[1 - Kafka 入门指南](./Kafka/1--Kafka入门指南.md)<br/>
&emsp;&emsp;&emsp;&emsp;[2 - Kafka 安装与应用举例](./Kafka/2--Kafka安装与应用举例.md)<br/>
&emsp;&emsp;&emsp;&emsp;[3 - Kafka 集群管理工具 Kafka-Manager 的安装使用](./Kafka/3--Kafka集群管理工具Kafka-Manager的安装使用.md)
## 九、ZooKeeper（分布式协调服务）
&emsp;&emsp;&emsp;&emsp;[1 - Zookeeper 入门指南](./Zookeeper/1--Zookeeper入门指南.md)
## 十、Cloudera Manager（大数据运维工具）
&emsp;&emsp;&emsp;&emsp;[1 - Cloudera Manager 入门指南](Cloudera/1--Cloudera入门指南.md)<br/>
&emsp;&emsp;&emsp;&emsp;[2 - 安装 Cloudera Manager 和 CDH](./Cloudera/2--安装ClouderaManager和CDH.md)
## 十一、Azkaban（批处理工作流调度器）
&emsp;&emsp;&emsp;&emsp;[1 - Azkaban 入门指南](./Azkaban/1--Azkaban入门指南.md)
## 十二、Elastic（分布式搜索和分析引擎）
&emsp;&emsp;&emsp;&emsp;[1 - Elastic 入门指南](./Elastic/1--Elastic入门指南.md)<br/>
&emsp;&emsp;&emsp;&emsp;[2 - 从诗词大会飞花令到 Elasticsearch 原理解析](./Elastic/2--从诗词大会飞花令到Elasticsearch原理解析.md)<br/>
&emsp;&emsp;&emsp;&emsp;[3 - ELKB 集群部署实例](./Elastic/3--ELKB集群部署实例.md)
## 十三、Docker（应用容器引擎）
&emsp;&emsp;&emsp;&emsp;[1 - Docker 入门指南](./Docker/1--Docker入门指南.md)<br/>
&emsp;&emsp;&emsp;&emsp;[2 - 从搬家到容器技术 Docker 应用场景解析](./Docker/2--从搬家到容器技术Docker应用场景解析.md)<br/>
&emsp;&emsp;&emsp;&emsp;[3 - CentOS7 安装 Docker 与应用举例](./Docker/3--CentOS7安装Docker与应用举例.md)
## 十四、Kubernetes（容器集群管理系统）
&emsp;&emsp;&emsp;&emsp;[1 - Kubernetes 入门指南](./Kubernetes/1--Kubernetes入门指南.md)<br/>
&emsp;&emsp;&emsp;&emsp;[2 - CentOS7 使用 kubeadm 部署 Kubernetes-1.18.8](./Kubernetes/2--CentOS7使用kubeadm部署Kubernetes-1.18.8.md)<br/>
&emsp;&emsp;&emsp;&emsp;[3 - Kubernetes 部署 Nginx 实例](./Kubernetes/3--Kubernetes部署Nginx实例.md)
