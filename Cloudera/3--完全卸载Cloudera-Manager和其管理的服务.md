<nav>
<a href="#1---环境信息">1 - 环境信息</a><br/>
<a href="#2---记录用户的数据目录">2 - 记录用户的数据目录</a><br/>
<a href="#2---停止所有服务">2 - 停止所有服务</a><br/>
<a href="#3---停用并移除-parcels">3 - 停用并移除 Parcels</a><br/>
<a href="#4---删除集群">4 - 删除集群</a><br/>
<a href="#5---卸载-cloudera-manager-server">5 - 卸载 Cloudera Manager Server</a><br/>
<a href="#6---卸载-cloudera-manager-agent-和其管理的服务">6 - 卸载 Cloudera Manager Agent 和其管理的服务</a><br/>
<a href="#7---删除-cloudera-manager-和用户数据">7 - 删除 Cloudera Manager 和用户数据</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#71---kill-cloudera-manager-和相关服务的进程">7.1 - Kill Cloudera Manager 和相关服务的进程</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#72---删除-cloudera-manager-数据">7.2 - 删除 Cloudera Manager 数据</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#73---删除-cloudera-manager-lock-file">7.3 - 删除 Cloudera Manager Lock File</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#74---删除用户数据">7.4 - 删除用户数据</a><br/>
</nav>

---

## 1 - 环境信息
- 操作系统：Centos 7.8
- JDK 版本：1.8.0_261
- Cloudera Manager 版本：5.9.3
- CDH 版本：5.9.3
- PostgreSQL 版本：9.2.24

## 2 - 记录用户的数据目录
**以下目录是 Cloudera 默认安装目录下个组件用户数据：：**
```bash
/var/lib/flume-ng
/var/lib/hadoop*
/var/lib/hue
/var/lib/navigator
/var/lib/oozie
/var/lib/solr
/var/lib/sqoop*
/var/lib/zookeeper
#data_drive_path 为集群环境部署时自定义的目录
data_drive_path/dfs
data_drive_path/mapred
data_drive_path/yarn
```

## 2 - 停止所有服务
登录 Cloudera Manager 管理平台，进入如下操作：
- 1、在 **主页 > 状态** 选项卡上，点击 `集群名称` 右侧的 ![标记](../images/cloudera/down_arrow.png)，然后选择 **停止**。
- 2、在确认页面中点击 **停止**。**停止命令** 窗口显示停止服务的进度。等待所有服务都正常被停止，点击 **完成**。
- 3、在 **主页 > 状态** 选项卡上，点击 `Cloudera Management Service` 右侧的 ![标记](../images/cloudera/down_arrow.png)，然后选择 **停止**。在确认页面中点击 **停止**。等待所有服务都正常被停止，点击 **完成**。

## 3 - 停用并移除 Parcels
点击 **Clouder Manager** 进入主页，并进入 Parcel 页面进行如下操作：
- 1、点击主导航栏中右上角的 ![Parcel](../images/cloudera/parcels_icon.png)。
- 2、在左侧的 **位置**，选择 **所有群集**。
- 3、对于每个激活的 `Parcel`，点击 **停用**。进入窗口选择 **仅限停用状态**，点击 **确定**。停用后，该按钮状态将变为 **激活**。
- 4、对于每个激活的 `Parcel`，点击 **激活**旁菜单中的 ![标记](../images/cloudera/down_arrow.png)，选择 **从主机中删除**，进入确认窗口，点击 **确定**。从主机删除成功后，该按钮状态将更改为 **分配**。
- 5、对于每个激活的 `Parcel`，点击 **分配**旁菜单中的 ![标记](../images/cloudera/down_arrow.png)，选择 **删除**，进入确认窗口，点击 **确定**。删除成功后，该按钮状态将更改为 **下载**。

**说明：** 如果集群中还有其它 Parcel，例如 KAFKA、ELASTICSEARCH、PRESTO 和 SPARK2 等，还需要将上面的步骤再操作一遍，即 **`停用` > `从集群中删除` > `删除`**。

## 4 - 删除集群
点击 **Clouder Manager** 进入主页，进行如下操作：
1、在 **主页 > 状态** 选项卡上，点击 `集群名称` 右侧的 ![标记](../images/cloudera/down_arrow.png)，然后选择 **删除**。
2、进入 **删除集群 Cluster 1** 页面。点击 **删除**。删除成功后，通过 Cloudera Manager 已经看不到集群。

## 5 - 卸载 Cloudera Manager Server
**1、停止 Cloudera Manager Server 和数据库**
```bash
$ sudo systemctl stop cloudera-scm-server

#如果使用内置 PostgreSQL 需要停止该服务，没有则忽略
$ sudo systemctl stop cloudera-scm-server-db
```

**2、卸载 Cloudera Manager Server 和数据库**
```bash
$ sudo yum remove cloudera-manager-server

#如果使用内置 PostgreSQL 需要停止该服务，没有则忽略
$ sudo yum remove cloudera-manager-server-db-2
```

## 6 - 卸载 Cloudera Manager Agent 和其管理的服务
**1、所有节点停止 Cloudera Manager Agent 服务**
```bash
$ sudo systemctl stop cloudera-scm-agent.service
```

**2、所有节点卸载 Cloudera 管理的所有服务**
```bash
$ sudo yum remove 'cloudera-manager-*' avro-tools crunch flume-ng hadoop-hdfs-fuse hadoop-hdfs-nfs3 hadoop-httpfs hadoop-kms hbase-solr hive-hbase hive-webhcat hue-beeswax hue-hbase hue-impala hue-pig hue-plugins hue-rdbms hue-search hue-spark hue-sqoop hue-zookeeper impala impala-shell kite llama mahout oozie pig pig-udf-datafu search sentry solr-mapreduce spark-core spark-master spark-worker spark-history-server spark-python sqoop sqoop2 whirr hue-common oozie-client solr solr-doc sqoop2-client zookeeper
```

**3、所有节点运行 clean 命令**
```bash
$ sudo yum clean all
```

## 7 - 删除 Cloudera Manager 和用户数据
### 7.1 - Kill Cloudera Manager 和相关服务的进程
在集群中所有节点执行如下操作，终止所有正在运行的 Cloudera Manager 和 Managed 进程：
```bash
$ for u in cloudera-scm flume hadoop hdfs hbase hive httpfs hue impala llama mapred oozie solr spark sqoop sqoop2 yarn zookeeper; do sudo kill $(ps -u $u -o pid=); done
```

**注意：** 如果前面正确停止了所有服务和 Cloudera Manager Agent，则无需执行此步骤。

### 7.2 - 删除 Cloudera Manager 数据
在集群中所有节点执行如下操作，删除所有 Cloudera Manager 数据：
```bash
$ sudo umount cm_processes
$ sudo rm -rf /usr/share/cmf /var/lib/cloudera* /var/cache/yum/cloudera* /var/log/cloudera* /var/run/cloudera* /opt/cloudera /usr/lib64/cmf /var/cache/yum/x86_64/7/cloudera* /etc/cloudera*
```

**注意：** 如果使用内置 PostgreSQL 数据库，则该数据存储在 `/var/lib/cloudera-scm-server-db`。

### 7.3 - 删除 Cloudera Manager Lock File
在集群中所有节点执行如下操作，删除 Cloudera Manager Lock File：
```bash
$ sudo rm /tmp/.scm_prepare_node.lock
```

### 7.4 - 删除用户数据
此步骤将永久删除所有用户数据。如果需要备份数据，在开始卸载过程之前使用 `distcp` 命令将其复制到另一个集群中。在集群中所有节点执行如下命令，删除用户所有数据：
```bash
#删除用户数据目录
$ sudo rm -rf /var/lib/flume-ng /var/lib/hadoop* /var/lib/yarn* /var/lib/hue /var/lib/navigator /var/lib/oozie /var/lib/solr /var/lib/sqoop* /var/lib/zookeeper /var/lib/hbase /var/lib/hive* /var/lib/impala /var/lib/llama /var/lib/sentry /var/lib/spark* /var/lib/kafka /var/lib/kudu /var/lib/impala /var/lib/elasticsearch /var/lib/flink /var/lib/presto /var/lib/pgsql

#删除配置文件目录
$ sudo rm -rf /etc/flume-ng /etc/hadoop* /etc/hbase* /etc/hive* /etc/hue /etc/pig /etc/sentry /etc/solr /etc/spark* /etc/sqoop* /etc/zookeeper* /etc/elasticsearch* /etc/impala /etc/alternatives

#删除日志目录
$ sudo rm -rf /var/log/hive /var/log/hbase /var/log/hadoop* /var/log/zookeeper /var/log/impalad /var/log/kafka /var/log/elasticsearch /var/log/flink

#data_drive_path 为集群环境部署时自定义的目录
$ sudo rm -rf data_drive_path/dfs data_drive_path/mapred data_drive_path/yarn

#删除临时目录
$ sudo rm -rf /tmp/cmf* /tmp/scm*
```

> 参考官方卸载文档：https://www.cloudera.com/documentation/enterprise/5-9-x/topics/cm_ig_uninstall_cm.html#cmig_topic_18
