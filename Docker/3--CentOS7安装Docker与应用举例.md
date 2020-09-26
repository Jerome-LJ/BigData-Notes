<nav>
<a href="#1---准备工作"</a>1 - 准备工作</a><br/>
<a href="#2---使用-yum-安装"</a>2 - 使用 yum 安装</a><br/>
<a href="#3---启动-docker-ce"</a>3 - 启动 Docker CE</a><br/>
<a href="#4---建立-docker-用户组"</a>4 - 建立 docker 用户组</a><br/>
<a href="#5---测试-docker-是否安装正确"</a>5 - 测试 Docker 是否安装正确</a><br/>
<a href="#6---镜像加速"</a>6 - 镜像加速</a><br/>
<a href="#7---添加内核参数"</a>7 - 添加内核参数</a><br/>
<a href="#8---docker-常用命令"</a>8 - Docker 常用命令</a><br/>
<a href="#9---入门实例以-nginx-为例"</a>9 - 入门实例（以 Nginx 为例）</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#91---通过-docker-pull-构建镜像"</a>9.1 - 通过 Docker Pull 构建镜像</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#92---通过-dockerfile-构建镜像"</a>9.2 - 通过 Dockerfile 构建镜像</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#93---使用-nginx-镜像"</a>9.3 - 使用 Nginx 镜像</a><br/>
</nav>

---

## 1 - 准备工作
**1、系统要求**

Docker CE 支持 64 位版本 `CentOS 7`，并且要求内核版本不低于 `3.10`。CentOS 7 满足最低内核的要求，但由于内核版本比较低，部分功能（如 `overlay2` 存储层驱动）无法使用，并且部分功能可能不太稳定。

**2、卸载旧版本**

旧版本的 Docker 称为 `docker` 或者 `docker-engine`，使用以下命令卸载旧版本：
```bash
$ sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
```

## 2 - 使用 yum 安装
> **注意：** 切勿在没有配置 Docker Yum 源的情况下直接使用 yum 命令安装 Docker。

**1、执行以下命令安装依赖包**
```bash
$ sudo yum install -y yum-utils \
           device-mapper-persistent-data \
           lvm2
```
鉴于国内网络问题，强烈建议使用`国内源`，官方源请在注释中查看。

**2、执行下面的命令添加 yum 软件源**
```bash
$ sudo yum-config-manager \
    --add-repo \
    https://mirrors.ustc.edu.cn/docker-ce/linux/centos/docker-ce.repo

$ sudo sed -i 's/download.docker.com/mirrors.ustc.edu.cn\/docker-ce/g' /etc/yum.repos.d/docker-ce.repo

# 官方源
# $ sudo yum-config-manager \
#     --add-repo \
#     https://download.docker.com/linux/centos/docker-ce.repo
```

**3、如无需要则忽略**

如果需要测试版本的 Docker CE 请使用以下命令：
```bash
$ sudo yum-config-manager --enable docker-ce-test
```
如果需要每日构建版本的 Docker CE 请使用以下命令：
```bash
$ sudo yum-config-manager --enable docker-ce-nightly
```

**4、安装 Docker CE**

更新 yum 软件源缓存，并安装 docker-ce。
```bash
$ sudo yum makecache fast
$ sudo yum install docker-ce
```

## 3 - 启动 Docker CE
```bash
$ sudo systemctl enable docker
$ sudo systemctl start docker
```

## 4 - 建立 docker 用户组
默认情况下，docker 命令会使用 Unix socket 与 Docker 引擎通讯。而只有 `root` 用户和 `docker` 组的用户才可以访问 Docker 引擎的 Unix socket。出于安全考虑，一般 Linux 系统上不会直接使用 root 用户。因此，更好地做法是将需要使用 `docker` 的用户加入 `docker` 用户组。

**1、建立 docker 组**
```bash
$ sudo groupadd docker
```

**2、将当前用户加入 docker 组**
```bash
$ sudo usermod -aG docker $USER
```
退出当前终端并重新登录，进行如下测试。

## 5 - 测试 Docker 是否安装正确
```bash
$ docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
0e03bdcc26d7: Pull complete 
Digest: sha256:49a1c8800c94df04e9658809b006fd8a686cab8028d33cfba2cc049724254202
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

```
若能正常输出以上信息，则说明安装成功。

## 6 - 镜像加速
如果在使用过程中发现拉取 Docker 镜像十分缓慢，可以配置 Docker 国内镜像加速。

**1、镜像加速器**

对于使用 systemd 的系统，请在 `/etc/docker/daemon.json` 中写入如下内容（如果文件不存在请新建该文件）
```bash
$ sudo cat /etc/docker/daemon.json
{
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
```
> 注意：一定要保证该文件符合 json 规范，否则 Docker 将不能启动。

**之后重新启动服务。**
```bash
$ sudo systemctl daemon-reload
$ sudo systemctl restart docker
```

**2、检查加速器是否生效**

执行 `$ docker info`，如果从结果中看到了如下内容，说明配置成功。
```bash
$ docker info
...
...
Registry Mirrors:
 https://hub-mirror.c.163.com/
 https://mirror.baidubce.com/
...
```

## 7 - 添加内核参数
如果在 CentOS 使用 Docker CE 看到下面的这些警告信息：
```bash
WARNING: bridge-nf-call-iptables is disabled
WARNING: bridge-nf-call-ip6tables is disabled
```
请添加内核配置参数以启用这些功能。
```
$ sudo tee -a /etc/sysctl.conf <<-EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
```
然后重新加载 sysctl.conf 即可。
```
$ sudo sysctl -p
```
参考 Docker 官方 CentOS 安装文档：https://docs.docker.com/engine/install/centos/


## 8 - Docker 常用命令
```bash
#列出镜像
$ docker image ls

#查看镜像体积
$ docker system df

#虚悬镜像(既没有仓库名，也没有标签，均为 <none>)
$ docker image ls -f dangling=true
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
<none>              <none>              00285df0df87        5 days ago          342 MB
#一般来说，虚悬镜像已经失去了存在的价值，是可以随意删除的，可以用下面的命令删除。
$ docker image prune

#中间层镜像
$ docker image ls -a

#列出部分镜像
$ docker image ls ubuntu

#删除 centos 镜像，可以用镜像名，也就是 <仓库名>:<标签>
$ docker image rmi centos

#删除所有仓库名为 redis 的镜像
$ docker image rmi $(docker image ls -q redis)

#删除所有在 mongo:3.2 之前的镜像
$ docker image rmi $(docker image ls -q -f before=mongo:3.2)

#以特定格式显示
#列出镜像ID
$ docker image ls -q

#列出只包含镜像ID和仓库名
$ docker image ls --format "{{.ID}}: {{.Repository}}"

#列出含标题、并只包含镜像ID和仓库名
$ docker image ls --format "table {{.ID}}\t{{.Repository}}"

#列出容器
$ docker ps

#显示所有的容器，包括未运行的
$ docker ps -a

#显示总的文件大小
$ docker ps -s

#停止所有的容器，这样才能够删除其中的镜像
$ docker stop $(docker ps -a -q)

# 删除所有的容器
$ docker rm $(docker ps -a -q)

#导出容器
$ docker export 7691a814370e > ubuntu.tar

#导入容器快照
$ cat ubuntu.tar | docker import - test/ubuntu:v1.0

#进入容器内
$ docker exec -it 8d885cc61a69 bash
```

## 9 - 入门实例（以 Nginx 为例）
以 Docker 安装 Nginx 为例，分别为：
- 通过 Docker Pull 构建镜像（直接从 HUB 拉取镜像）
- 通过 Dockerfile 构建镜像

### 9.1 - 通过 Docker Pull 构建镜像
**1、查看可用版本**
```bash
$ docker search nginx
```

**2、拉取官方的镜像**
```bash
$ docker pull nginx
```

**3、查看 Nginx 镜像**
```bash
$ docker images | grep nginx
nginx               latest              08393e824c32        Less than a second ago   132MB
```

### 9.2 - 通过 Dockerfile 构建镜像
以 [nginx-1.18.0.tar.gz](http://nginx.org/download/nginx-1.18.0.tar.gz) 为例，提前下载好放到 `~/nginx/` 目录。

**1、创建目录并下载 Nginx**
```bash
$ mkdir ~/nginx/
$ cd ~/nginx/
$ wget http://nginx.org/download/nginx-1.18.0.tar.gz
```

**2、编写 Dockerfile 文件**

**方法一：直接构建镜像**
```bash
$ cat Dockerfile.v1
FROM centos:7.6.1810

MAINTAINER Jerome

ADD nginx-1.18.0.tar.gz /opt/

RUN yum -y install gcc make pcre-devel zlib-devel zlib      \
    && yum clean all                \
    && cd /opt/nginx-1.18.0         \
    && mkdir /usr/local/nginx       \
    && ./configure --prefix=/usr/local/nginx && make && make install    \
    && ln -s /usr/local/nginx/sbin/nginx /usr/local/sbin/   \
    && nginx                        \
    && rm -rf /opt/nginx-1.18.0     \
    && echo '<h1>Hello, Docker!</h1>' > /usr/local/nginx/html/index.html

EXPOSE 80

WORKDIR /usr/local/nginx/

CMD ["nginx", "-g", "daemon off;"]
```

**方法二：多阶段构建镜像**
```bash
$ cat Dockerfile.v2
FROM centos:7.6.1810 as build
MAINTAINER Jerome

EXPOSE 80

WORKDIR /opt

RUN yum install -y gcc make pcre-devel zlib-devel zlib wget tar         \
    && yum clean all    \
    && wget 'http://nginx.org/download/nginx-1.18.0.tar.gz' \
    && tar -xzvf nginx-1.18.0.tar.gz    \
    && cd /opt/nginx-1.18.0     \
    && ./configure --prefix=/usr/local/nginx && make && make install    \
    && rm -rf /opt/nginx-1.18.0*        \
    && echo '<h1>Hello, Docker!</h1>' > /usr/local/nginx/html/index.html

FROM centos:7.6.1810 
MAINTAINER Jerome

EXPOSE 80

VOLUME ["/usr/local/nginx/html"]

COPY --from=build /usr/local/nginx /usr/local/nginx

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
```

更多 DockerFiles 参考：https://github.com/Jerome-LJ/DockerFiles

**3、通过 Dockerfile 创建镜像**
```bash
#选择其中任一方法即可。
$ docker build -t nginx:v1.0 -f ./Dockerfile.v1 .
$ docker build -t nginx:v2.0 -f ./Dockerfile.v2 .
...
...
Step 7/7 : CMD ["nginx", "-g", "daemon off;"]
 ---> Running in 45583b032541
Removing intermediate container 45583b032541
 ---> b31dd0353797
Successfully built b31dd0353797
Successfully tagged nginx:v1.0
```

**4、查看创建好的 Nginx 的镜像**
```bash
$ $ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nginx               v1.0                b31dd0353797        15 seconds ago      308MB
nginx               v2.0                8c17b1475c56        2 hours ago         206MB
centos              7.6.1810            831691599b88        5 weeks ago         202MB
```
由此可以看出，nginx:v2.0 是多阶段构建镜像，最大化缩减容器占比。

### 9.3 - 使用 Nginx 镜像
**1、运行容器**
```bash
$ docker run --name nginx -p 80:80 -d nginx:v1.0
822c5e7b0c64c6d5df483f3a8751ab6ad160e6c40535f37e1fdacf3722c577b5
```

**2、查看容器运行情况**
```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
822c5e7b0c64        nginx:v1.0          "nginx -g 'daemon of…"   13 minutes ago      Up 1 minutes        0.0.0.0:80->80/tcp   nginx

#进入容器内
$ docker exec -it 822c5e7b0c64 bash
```

**3、通过浏览器访问**

http://172.16.1.11:80/
