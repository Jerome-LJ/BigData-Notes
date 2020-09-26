<nav>
<a href="#1---准备工作">1 - 准备工作</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#11---查看系统版本">1.1 - 查看系统版本</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#12---配置网络">1.2 - 配置网络</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#13---修改-yum-源添加阿里源">1.3 - 修改 yum 源，添加阿里源</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#14---修改-hostname添加-etchosts">1.4 - 修改 hostname、添加 /etc/hosts</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#15---关闭防火墙selinuxswap">1.5 - 关闭防火墙、selinux、swap</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#16---添加内核参数">1.6 - 添加内核参数</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#17---安装依赖包">1.7 - 安装依赖包</a><br/>
<a href="#2---docker-ce">2 - Docker-CE</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#21---安装-docker-ce">2.1 - 安装 Docker-CE</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#22---添加镜像加速器">2.2 - 添加镜像加速器</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#23---检查加速器是否生效">2.3 - 检查加速器是否生效</a><br/>
<a href="#3---kubectlkubeletkubeadm">3 - kubectl、kubelet、kubeadm</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#31---添加阿里-kubernetes-源">3.1 - 添加阿里 Kubernetes 源</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#32-安装-kubectlkubeletkubeadm">3.2 安装 kubectl、kubelet、kubeadm</a><br/>
<a href="#4---初始化-k8s-集群">4 - 初始化 K8S 集群</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#41---使用阿里云镜像仓库初始化-k8s-集群">4.1 - 使用阿里云镜像仓库初始化 K8S 集群</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#42---根据提示执行初始化时提供的命令">4.2 - 根据提示，执行初始化时提供的命令</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#43---添加-kubectl-自动补充命令">4.3 - 添加 kubectl 自动补充命令</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#44---查看节点pod">4.4 - 查看节点、POD</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#45---安装-calico-网络">4.5 - 安装 calico 网络</a><br/>
<a href="#5---kubernetes-dashboard">5 - kubernetes-dashboard</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#51---下载-recommendedyaml">5.1 - 下载 recommended.yaml</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#52---修改-recommendedyaml">5.2 - 修改 recommended.yaml</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#53---安装-kubernetes-dashboard">5.3 - 安装 kubernetes-dashboard</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#54---通过页面访问-kubernetes-dashboard">5.4 - 通过页面访问 kubernetes-dashboard</a><br/>
<a href="#6---卸载脚本">6 - 卸载脚本</a><br/>
</nav>

---

## 1 - 准备工作
### 1.1 - 查看系统版本
```bash
[root@localhost]# cat /etc/centos-release
CentOS Linux release 7.8.2003 (Core)

[root@localhost]# hostname -i
172.16.1.11

```

### 1.2 - 配置网络
```bash
[root@localhost ~]# cat  /etc/sysconfig/network-scripts/ifcfg-ens33
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens33
UUID=1305dbac-3349-4efc-8ac8-cb8829856311
DEVICE=ens33
ONBOOT=yes
IPADDR=172.16.1.11
NETMASK=255.255.255.0
GATEWAY=172.16.1.2
DNS1=8.8.8.8

##重启网卡服务
[root@localhost ~]# systemctl restart network
```

### 1.3 - 修改 yum 源，添加阿里源
```bash
[root@localhost ~]# curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-8.repo
```

### 1.4 - 修改 hostname、添加 /etc/hosts
```bash
[root@kubernetes ~]# hostnamectl set-hostname kubernetes.test.com
[root@kubernetes ~]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

172.16.1.11    kubernetes.test.com    master
```

### 1.5 - 关闭防火墙、selinux、swap
```bash
##关闭防火墙
[root@kubernetes ~]# systemctl stop firewalld
[root@kubernetes ~]# systemctl disable firewalld

## 关闭 Selinux
[root@kubernetes ~]# setenforce 0
[root@kubernetes ~]# sed -i "s/^SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

##关闭 swap，注释 swap 分区
[root@kubernetes ~]# swapoff -a
[root@kubernetes ~]# cat /etc/fstab
#
# /etc/fstab
# Created by anaconda on Thu Aug 13 18:48:37 2020
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/centos-root                     /           xfs     defaults        0 0
UUID=30b5ff64-4613-4daa-8d2c-774489c25f06   /boot       xfs     defaults        0 0
#/dev/mapper/centos-swap                    swap        swap    defaults        0 0
```

### 1.6 - 添加内核参数
添加内核配置参数以启用这些功能
```bash
[root@kubernetes ~]# tee -a /etc/sysctl.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

##重新加载 sysctl.conf 即可
[root@kubernetes ~]# sysctl -p
```

### 1.7 - 安装依赖包
```bash
[root@kubernetes ~]# yum install -y bash-completion gcc yum-utils device-mapper-persistent-data lvm2
```

## 2 - Docker-CE
### 2.1 - 安装 Docker-CE
```bash
##添加 yum 软件源
[root@kubernetes ~]# yum-config-manager --add-repo https://mirrors.ustc.edu.cn/docker-ce/linux/centos/docker-ce.repo
[root@kubernetes ~]# sed -i 's/download.docker.com/mirrors.ustc.edu.cn\/docker-ce/g' /etc/yum.repos.d/docker-ce.repo
##更新 yum 软件源缓存
[root@kubernetes ~]# yum makecache fast
##安装 Docker-CE
[root@kubernetes ~]# yum install docker-ce
```

### 2.2 - 添加镜像加速器
对于使用 systemd 的系统，请在 `/etc/docker/daemon.json` 中写入如下内容（如果文件不存在请新建该文件）
```bash
[root@kubernetes ~]# cat /etc/docker/daemon.json
{
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
```
之后重新启动服务。
```bash
[root@kubernetes ~]# systemctl daemon-reload
[root@kubernetes ~]# systemctl restart docker
```

### 2.3 - 检查加速器是否生效
执行 `# docker info`，如果从结果中看到了如下内容，说明配置成功。
```bash
[root@kubernetes ~]# docker info
...
...
Registry Mirrors:
 https://hub-mirror.c.163.com/
 https://mirror.baidubce.com/
...
```

## 3 - kubectl、kubelet、kubeadm
### 3.1 - 添加阿里 Kubernetes 源
```bash
[root@kubernetes ~]# cat > /etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
```

### 3.2 安装 kubectl、kubelet、kubeadm
```bash
[root@kubernetes ~]# yum install -y kubectl-1.18.8-0 kubelet-1.18.8-0 kubeadm-1.18.8-0
[root@kubernetes ~]# systemctl enable kubelet
```

## 4 - 初始化 K8S 集群
### 4.1 - 使用阿里云镜像仓库初始化 K8S 集群
由于 kubeadm 默认从官网 k8s.grc.io 下载所需镜像，国内无法访问，因此需要通过 `--image-repository` 指定阿里云镜像仓库地址。
```bash
[root@kubernetes ~]# kubeadm init --kubernetes-version=v1.18.0  \
    --apiserver-advertise-address=172.16.1.11  \
    --image-repository registry.aliyuncs.com/google_containers  \
    --service-cidr=172.16.1.0/16 --pod-network-cidr=172.16.1.0/16
```
集群初始化成功后返回如下信息：
```
......
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.16.1.11:6443 --token mjil5k.elfcs9fwswcmsknh \
    --discovery-token-ca-cert-hash sha256:012f1ef144902e506951733fdbd6b8e8e8d9983d66bc2df5cb56833c0641b794
```
**记录生成的最后部分内容，在其它节点上可以使用此命令将该节点加入该 K8S 集群。**

### 4.2 - 根据提示，执行初始化时提供的命令
```bash
[root@kubernetes ~]# mkdir -p $HOME/.kube
[root@kubernetes ~]# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
[root@kubernetes ~]# sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### 4.3 - 添加 kubectl 自动补充命令
```bash
[root@kubernetes ~]# source <(kubectl completion bash)
```

### 4.4 - 查看节点、POD
```bash
[root@kubernetes ~]# kubectl get node
NAME                  STATUS     ROLES    AGE     VERSION
kubernetes.test.com   NotReady   master   8m35s   v1.18.8
[root@kubernetes ~]# kubectl get pod --all-namespaces
NAMESPACE     NAME                                          READY   STATUS    RESTARTS   AGE
kube-system   coredns-7ff77c879f-5b5sg                      0/1     Pending   0          8m27s
kube-system   coredns-7ff77c879f-mvx5s                      0/1     Pending   0          8m27s
kube-system   etcd-kubernetes.test.com                      1/1     Running   0          8m44s
kube-system   kube-apiserver-kubernetes.test.com            1/1     Running   0          8m44s
kube-system   kube-controller-manager-kubernetes.test.com   1/1     Running   0          8m44s
kube-system   kube-proxy-9d8th                              1/1     Running   0          8m27s
kube-system   kube-scheduler-kubernetes.test.com            1/1     Running   0          8m44s
```
可以看到，node 节点为 Pending 状态，因为 coredns pod 没有启动，缺少网络 pod。

### 4.5 - 安装 calico 网络
```bash
[root@kubernetes ~]# kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
configmap/calico-config created
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
clusterrole.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrolebinding.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrole.rbac.authorization.k8s.io/calico-node created
clusterrolebinding.rbac.authorization.k8s.io/calico-node created
daemonset.apps/calico-node created
serviceaccount/calico-node created
deployment.apps/calico-kube-controllers created
serviceaccount/calico-kube-controllers created
```
在查看节点、POD
```bash
[root@kubernetes ~]# kubectl get node
NAME                  STATUS   ROLES    AGE   VERSION
kubernetes.test.com   Ready    master   11m   v1.18.8
[root@kubernetes ~]# kubectl get pod --all-namespaces
NAMESPACE     NAME                                          READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-578894d4cd-2h544      1/1     Running   0          61s
kube-system   calico-node-rh8vf                             1/1     Running   0          61s
kube-system   coredns-7ff77c879f-5b5sg                      1/1     Running   0          10m
kube-system   coredns-7ff77c879f-mvx5s                      1/1     Running   0          10m
kube-system   etcd-kubernetes.test.com                      1/1     Running   0          11m
kube-system   kube-apiserver-kubernetes.test.com            1/1     Running   0          11m
kube-system   kube-controller-manager-kubernetes.test.com   1/1     Running   0          11m
kube-system   kube-proxy-9d8th                              1/1     Running   0          10m
kube-system   kube-scheduler-kubernetes.test.com            1/1     Running   0          11m
```
此时集群状态已经全部是 Running 正常。

## 5 - kubernetes-dashboard
官方部署 dashboard 的服务没使用 nodeport，将 yaml 文件下载到本地，在 Service 里添加 NodePort
### 5.1 - 下载 recommended.yaml
```bash
[root@kubernetes ~]# wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
```
如果 GitHub 的 raw.githubusercontent.com 无法连接
- 修改 `/etc/hosts` 临时解决 GitHub 的 `raw.githubusercontent.com` 无法连接问题
- 通过 [IPAddress.com](https://www.ipaddress.com/) 首页，输入 `raw.githubusercontent.com` 查询到真实IP地址
199.232.68.133
- 添加以下内容并保存即可恢复
```bash
[root@kubernetes ~]# echo "199.232.68.133 raw.githubusercontent.com" >> /etc/hosts
```

### 5.2 - 修改 recommended.yaml
```bash
[root@kubernetes ~]# vim recommended.yaml
 32 kind: Service
 33 apiVersion: v1
 34 metadata:
 35   labels:
 36     k8s-app: kubernetes-dashboard
 37   name: kubernetes-dashboard
 38   namespace: kubernetes-dashboard
 39 spec:
 40   type: NodePort    ##增加 NodePort
 41   ports:
 42     - port: 443
 43       targetPort: 8443
 44       nodePort: 30000   ##增加 NodePort 端口
 45   selector:
 46     k8s-app: kubernetes-dashboard
```

### 5.3 - 安装 kubernetes-dashboard
```bash
[root@kubernetes ~]# kubectl create -f recommended.yaml
namespace/kubernetes-dashboard created
serviceaccount/kubernetes-dashboard created
service/kubernetes-dashboard created
secret/kubernetes-dashboard-certs created
secret/kubernetes-dashboard-csrf created
secret/kubernetes-dashboard-key-holder created
configmap/kubernetes-dashboard-settings created
role.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
deployment.apps/kubernetes-dashboard created
service/dashboard-metrics-scraper created
deployment.apps/dashboard-metrics-scraper created
```
查看 pod、Service
```bash
[root@kubernetes ~]# kubectl get pod --all-namespaces
NAMESPACE              NAME                                          READY   STATUS    RESTARTS   AGE
kube-system            calico-kube-controllers-578894d4cd-2h544      1/1     Running   0          11m
kube-system            calico-node-rh8vf                             1/1     Running   0          11m
kube-system            coredns-7ff77c879f-5b5sg                      1/1     Running   0          21m
kube-system            coredns-7ff77c879f-mvx5s                      1/1     Running   0          21m
kube-system            etcd-kubernetes.test.com                      1/1     Running   0          21m
kube-system            kube-apiserver-kubernetes.test.com            1/1     Running   0          21m
kube-system            kube-controller-manager-kubernetes.test.com   1/1     Running   0          21m
kube-system            kube-proxy-9d8th                              1/1     Running   0          21m
kube-system            kube-scheduler-kubernetes.test.com            1/1     Running   0          21m
kubernetes-dashboard   dashboard-metrics-scraper-6b4884c9d5-8sb95    1/1     Running   0          91s
kubernetes-dashboard   kubernetes-dashboard-7f99b75bf4-hfz75         1/1     Running   0          91s
[root@kubernetes ~]# 
[root@kubernetes ~]# kubectl get svc -n kubernetes-dashboard
NAME                        TYPE        CLUSTER-IP        EXTERNAL-IP   PORT(S)        AGE
dashboard-metrics-scraper   ClusterIP   172.16.6.57      <none>        8000/TCP        93s
kubernetes-dashboard        NodePort    172.16.8.55      <none>        443:30000/TCP   93s
```

### 5.4 - 通过页面访问 kubernetes-dashboard
https://172.16.1.11:30000/

使用 Token 进行登录

通过 secret 获取凭证
```bash
[root@kubernetes ~]# kubectl -n kubernetes-dashboard get secret
NAME                               TYPE                                  DATA   AGE
default-token-fv789                kubernetes.io/service-account-token   3      7m54s
kubernetes-dashboard-certs         Opaque                                0      7m54s
kubernetes-dashboard-csrf          Opaque                                1      7m54s
kubernetes-dashboard-key-holder    Opaque                                2      7m54s
kubernetes-dashboard-token-w8pnb   kubernetes.io/service-account-token   3      7m54s
```
获取 secret 中的 Token
```bash
[root@kubernetes ~]# kubectl describe secrets -n kubernetes-dashboard kubernetes-dashboard-token-w8pnb | grep token | awk 'NR==3{print $2}'
eyJhbGciOiJSUzI1NiIsImtpZCI6ImhHVzM2UG54MjdEM3lPRzB3NU9MbERnMWN5dWRxaHpxMkU2M1N6SmxDNFEifQ......
```

登录后，如果没有 namespace 可选，并且提示 `这里没有可以显示的` ，那么就是权限问题

通过查看 dashboard 日志，得到如下信息
```bash
[root@kubernetes ~]# kubectl logs -f -n kubernetes-dashboard kubernetes-dashboard-7f99b75bf4-hfz75
2020/08/19 11:35:11 [2020-08-19T11:35:11Z] Incoming HTTP/2.0 GET /api/v1/replicationcontroller/default?itemsPerPage=10&page=1&sortBy=d,creationTimestamp request from 172.16.1.11:35021: 
2020/08/19 11:35:11 Getting list of all replication controllers in the cluster
2020/08/19 11:35:11 Getting list of all replica sets in the cluster
2020/08/19 11:35:11 Non-critical error occurred during resource retrieval: replicationcontrollers is forbidden: User "system:serviceaccount:kubernetes-dashboard:kubernetes-dashboard" cannot list resource "replicationcontrollers" in API group "" in the namespace "default"
2020/08/19 11:35:11 Non-critical error occurred during resource retrieval: pods is forbidden: User "system:serviceaccount:kubernetes-dashboard:kubernetes-dashboard" cannot list resource "pods" in API group "" in the namespace "default"
2020/08/19 11:35:11 Non-critical error occurred during resource retrieval: events is forbidden: User "system:serviceaccount:kubernetes-dashboard:kubernetes-dashboard" cannot list resource "events" in API group "" in the namespace "default"
2020/08/19 11:35:11 Non-critical error occurred during resource retrieval: jobs.batch is forbidden: User "system:serviceaccount:kubernetes-dashboard:kubernetes-dashboard" cannot list resource "jobs" in API group "batch" in the namespace "default"
2020/08/19 11:35:11 Non-critical error occurred during resource retrieval: pods is forbidden: User "system:serviceaccount:kubernetes-dashboard:kubernetes-dashboard" cannot list resource "pods" in API group "" in the namespace "default"
```
解决方法，添加权限
```bash
[root@kubernetes ~]# kubectl create clusterrolebinding serviceaccount-cluster-admin --clusterrole=cluster-admin --user=system:serviceaccount:kubernetes-dashboard:kubernetes-dashboard --group=system:serviceaccount
clusterrolebinding.rbac.authorization.k8s.io/serviceaccount-cluster-admin created
```

此时再查看 dashboard，`点击 <命名空间> --> <全部 namespaces>` 即可看到有资源展示。即安装完成。

## 6 - 卸载脚本
```bash
#!/bin/bash
systemctl disable kubelet
kubeadm reset -f
modprobe -r ipip
lsmod
rm -rf ~/.kube
rm -rf /etc/kubernetes
rm -rf /etc/systemd/system/kubelet.service.d
rm -rf /etc/systemd/system/kubelet.service
rm -rf /usr/bin/kube*
rm -rf /etc/cni
rm -rf /opt/cni
rm -rf /var/lib/etcd
rm -rf /var/lib/kubelet
rm -rf /var/etcd
rm -rf /var/log/containers
rm -rf /var/log/pods
yum -y remove kubeadm kubectl kubelet
```
