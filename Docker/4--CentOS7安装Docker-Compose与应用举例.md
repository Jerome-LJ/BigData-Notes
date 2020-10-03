<nav>
<a href="#1---docker-compose-简介"</a>1 - Docker Compose 简介</a><br/>
<a href="#2---docker-compose-安装与卸载"</a>2 - Docker Compose 安装与卸载</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#21---安装"</a>2.1 - 安装</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#22---卸载"</a>2.2 - 卸载</a><br/>
<a href="#3---docker-compose-常用命令"</a>3 - Docker Compose 常用命令</a><br/>
<a href="#4---入门实例部署-lnmpredis-环境为例"</a>4 - 入门实例（部署 LNMP+Redis 环境为例）</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#41---组件版本"</a>4.1 - 组件版本</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#42---目录结构"</a>4.2 - 目录结构</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#43---安装步骤"</a>4.3 - 安装步骤</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#44---测试访问"</a>4.4 - 测试访问</a><br/>
</nav>

---

## 1 - Docker Compose 简介
Docker Compose 是 Docker 官方编排（Orchestration）项目之一，负责快速的部署分布式应用。

Compose 是用于定义和运行多容器 Docker 应用程序的工具。通过 Compose，可以使用 `docker-compose.yml` 文件来配置应用程序需要的所有服务。然后，使用一个命令，就可以从 `docker-compose.yml` 文件配置中创建并启动所有服务。

## 2 - Docker Compose 安装与卸载
Compose 可以通过 Python 的包管理工具 pip 进行安装，也可以直接下载编译好的二进制文件使用，甚至能够直接在 Docker 容器中运行。

```bash
$ docker-compose --version
docker-compose version 1.27.4, build eefe0d31
```

### 2.1 - 安装
**1、二进制包**

从 [官方 GitHub Release](https://github.com/docker/compose/releases) 处直接下载编译好的二进制文件即可。
```bash
$ sudo curl -L https://github.com/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

**2、PIP 安装**

将 Compose 当作一个 Python 应用来从 pip 源中安装。
```bash
$ sudo pip install -U docker-compose
```

**3、bash 补全命令**
```bash
$ sudo su -c "curl -L https://raw.githubusercontent.com/docker/compose/1.27.4/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"
```

### 2.2 - 卸载
如果是二进制包方式安装的，删除二进制文件即可。
```bash
$ sudo rm /etc/bash_completion.d/docker-compose
$ sudo rm /usr/local/bin/docker-compose
```

如果是通过 PIP 安装的，则执行如下命令即可删除。
```bash
$ sudo pip uninstall docker-compose
$ sudo rm /etc/bash_completion.d/docker-compose
```

## 3 - Docker Compose 常用命令
```bash
#启动所有服务
docker-compose up
#在后台所有启动服务
docker-compose up -d
#-f 指定使用的 Compose 模板文件，默认为 docker-compose.yml
docker-compose -f docker-compose.yml up -d

#列出项目中目前的所有容器
docker-compose ps [options] [SERVICE...]

#停止正在运行的容器，可以通过 docker-compose start 再次启动
docker-compose stop [options] [SERVICE...]

#停止和删除容器、网络、卷、镜像
docker-compose down [options]

#查看服务容器的输出
docker-compose logs -f [options] [SERVICE...]

#重启项目中的服务
docker-compose restart [options] [SERVICE...]

#删除所有（停止状态的）服务容器。推荐先执行 docker-compose stop 命令来停止容器
docker-compose rm [options] [SERVICE...]

#启动已经存在的服务容器
docker-compose start [SERVICE...]

#在指定服务上执行一个命令
docker-compose run [options] [-v VOLUME...] [-p PORT...] [-e KEY=VAL...] SERVICE [COMMAND] [ARGS...]
#在指定容器上执行一个 ping 命令。
docker-compose run ubuntu ping www.baidu.com

#暂停一个服务容器
docker-compose pause [SERVICE...]

#通过发送SIGKILL信号来强制停止服务容器
docker-compose kill [options] [SERVICE...]

#验证并查看 compose 文件配置
docker-compose config [options]

#停止容器运行
docker-compose stop [options]

#打印版本信息
docker-compose version
```

## 4 - 入门实例（部署 LNMP+Redis 环境为例）
### 4.1 - 组件版本
```
Nginx: 1.18.0
MySQL: 5.7
PHP: 7.4.9-fpm-alpine
Redis: 6.0.6
```
### 4.2 - 目录结构
```
├── Docker_Compose_YAML
    └── LNMP-Compose
        ├── docker-compose.yml      Docker 服务配置示例文件
        ├── mysql                   MySQL 目录
        │   ├── data                数据库数据目录
        │   ├── log                 数据库日志目录
        │   └── my.cnf              数据库配置文件
        ├── nginx                   Nginx 目录
        │   ├── conf.d              Nginx 配置文件目录
        │   │   └── default.conf
        │   ├── log                 Nginx 日志目录
        │   └── nginx.conf          Nginx 配置文件
        ├── php                     PHP 目录
        │   ├── conf                PHP 配置文件目录
        │   │   ├── php-fpm.conf
        │   │   └── php.ini
        │   ├── Dockerfile          PHP Dockerfile 示例文件
        │   ├── log                 PHP 日志目录
        │   └── www                 PHP 代码文件目录
        │       ├── db.php
        │       ├── index.php
        │       └── redis.php
        ├── README.md               README
        └── redis                   Redis 目录
            ├── data                Redis 数据目录
            ├── log                 Redis 日志目录
            └── redis.conf          Redis 配置文件
```
### 4.3 - 安装步骤
使用 GitHub 代码安装
```bash
$ cd ~/
$ git clone https://github.com/Jerome-LJ/DockerFiles.git

$ cd ./DockerFiles/Docker_Compose_YAML/LNMP-Compose/
$ cp .env-example .env

# 配置数据库密码、端口等
$ vim .env

# 构建镜像并启动容器
$ docker-compose up --build -d
```
### 4.4 - 测试访问
使用 `docker ps` 查看容器启动状态，若全部正常启动。则通过访问如下链接，即可完成测试。
> http://127.0.0.1/
> 
> http://127.0.0.1/index.php
> 
> http://127.0.0.1/db.php
> 
> http://127.0.0.1/redis.php
