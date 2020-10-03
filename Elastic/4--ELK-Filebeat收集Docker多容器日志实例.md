<nav>
<a href="#1---环境信息">1 - 环境信息</a><br/>
<a href="#2---编写-filebeat-配置文件">2 - 编写 Filebeat 配置文件</a><br/>
<a href="#3---编写-docker-composeyml">3 - 编写 docker-compose.yml</a><br/>
<a href="#4---启动-docker-compose">4 - 启动 docker-compose</a><br/>
<a href="#5---配置-logstash-输入输出">5 - 配置 logstash 输入输出</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#51---inputconf">5.1 - input.conf</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#52---outputconf">5.2 - output.conf</a><br/>
<a href="#6---采集-docker-container-日志">6 - 采集 docker-container 日志</a><br/>
</nav>

---

## 1 - 环境信息
**以部署 ELK 集群模式为例，如果未安装 ELK 集群，请点击 [传送门](./3--ELKB集群部署实例.md)：**
- 操作系统：Centos 7.8
- Oracle JDK 版本：1.8.0_261
- ELKB 版本：7.8.1

<table>
	<tr>
	    <th>组件名称</th>
	    <th>节点</th>
	    <th>IP</th>
	</tr >
	<tr >
	    <td rowspan="3">Elasticsearch</td>
	    <td>es-node-01</td>
	    <td>172.16.1.11</td>
	</tr>
	<tr>
	    <td>es-node-02</td>
	    <td>172.16.1.12</td>
	</tr>
	<tr>
	    <td>es-node-03</td>
	    <td>172.16.1.13</td>
	</tr>
	<tr >
	    <td rowspan="2">Logstash</td>
	    <td>logstash-01</td>
	    <td>172.16.1.14</td>
	</tr>
	<tr>
	    <td>logstash-02</td>
	    <td>172.16.1.15</td>
	</tr>
	<tr >
	    <td>Filbeat</td>
	    <td>logstash-02</td>
	    <td>172.16.1.15</td>
	</tr>
</table>

## 2 - 编写 Filebeat 配置文件
```bash
$ mkdir -p /opt/bigdata/filebeat/conf
$ cat > /opt/bigdata/filebeat/conf/filebeat.yml <<-EOF
# ============================== Filebeat inputs ===============================
filebeat.inputs:
- type: container
  enabled: true
  paths: 
    #挂载到宿主机磁盘
    - '/mnt/containers/*/*.log'
  fields:
    type: docker

# ================================== Outputs ===================================
# ------------------------------ Logstash Output -------------------------------
output.logstash:
  # The Logstash hosts
  hosts: ["172.16.1.14:5044", "172.16.1.15:5044"]
  loadbalance: true

# ================================= Processors =================================
#过滤掉一些不必要字段
processors:
  - drop_fields:
      fields:
      - host
      - prospector
      - input
      - beat
      - log
EOF
```

## 3 - 编写 docker-compose.yml
```bash
$ cat > /opt/bigdata/filebeat/docker-compose.yml <<-EOF
version: "3"
services:
    filebeat:
        user: root
        container_name: filebeat
        image: docker.elastic.co/beats/filebeat:7.8.1
        volumes:
            - /opt/bigdata/filebeat/conf/filebeat.yml:/usr/share/filebeat/filebeat.yml
            # 宿主机 Docker 容器日志映射到 Filebeat 容器
            - /var/lib/docker/containers/:/mnt/containers/
EOF
```
## 4 - 启动 docker-compose
**如果没有 `docker-compose` 命令，先进行安装 [传送门](../Docker/4--CentOS7安装Docker-Compose与应用举例.md#2---docker-compose-安装与卸载)。**
```bash
$ sudo yum install python-pip
$ sudo pip install docker-compose
```
**启动 docker-compose**
```bash
#在后台所有启动服务
$ sudo docker-compose up -d
#列出项目中目前的所有容器
$ sudo docker-compose ps
#进入容器内执行 shell 命令
$ sudo docker exec -it filebeat bash
```

## 5 - 配置 logstash 输入输出
### 5.1 - input.conf
```bash
input {
    beats {
        port => 5044
        client_inactivity_timeout => 86400
    }
}
```

### 5.2 - output.conf
```bash
output {
    if "_grokparsefailure" in [tags] {
        elasticsearch {
            hosts => ["http://172.16.1.11:9200", "http://172.16.1.12:9200", "http://172.16.1.13:9200"]
            manage_template => false
            index => "grok_failures-%{+YYYY.MM.dd}"
        }
    }
    else if [docker][attrs][service] {
        elasticsearch {
            hosts => ["http://172.16.1.11:9200", "http://172.16.1.12:9200", "http://172.16.1.13:9200"]
            manage_template => false
            index => "%{[docker][attrs][service]}-%{+YYYY.MM.dd}"
            user => "elastic"
            password => "jlpay@es"
        }
    }
    else {
        elasticsearch {
            hosts => ["http://172.16.1.11:9200", "http://172.16.1.12:9200", "http://172.16.1.13:9200"]
            manage_template => false
            index => "%{[fields][type]}-%{+YYYY.MM.dd}"
            user => "elastic"
            password => "jlpay@es"
        }
    }
}
```

## 6 - 采集 docker-container 日志
给具体的 Docker 容器增加 labels，并且设置 logging。参考示例如下：
```bash
version: '3'
services:
  mysql:
    image: mysql:5.7
    #设置 labels
    labels:
      service: mysql
    #logging 设置增加 labels.service
    logging:
      options:
        labels: "service"
    ports:
      - "3306:3306"
```

重新启动容器服务。
```bash
$ docker-compose restart mysql
```

访问 Kibana: `http://127.0.0.1:5601` 重新添加索引 `mysql-*`。查看日志，可以增加过滤条件 `docker.attrs.service:mysql`，此时查看到的日志就全部来自 MySQL 容器。
