<nav>
<a href="#1---创建-nginx-rcyaml">1 - 创建 nginx-rc.yaml</a><br/>
<a href="#2---创建-nginx-svcyaml">2 - 创建 nginx-svc.yaml</a><br/>
<a href="#3---创建-pod">3 - 创建 Pod</a><br/>
<a href="#4---创建-service">4 - 创建 Service</a><br/>
<a href="#5---查看-pod">5 - 查看 Pod</a><br/>
<a href="#6---查看-service">6 - 查看 Service</a><br/>
<a href="#7---测试-nginx">7 - 测试 Nginx</a><br/>
</nav>

---

## 1 - 创建 nginx-rc.yaml
Kubernetes Pod 是由一个或多个为了管理和联网而绑定在一起的容器构成的组。本教程中的 Pod 只有一个容器。Kubernetes ReplicationController 检查 Pod 的健康状况，并在 Pod 中的容器终止的情况下重新启动新的容器。ReplicationController 确保在任何时候都有特定数量的 Pod 副本处于运行状态。 换句话说，ReplicationController 确保一个 Pod 或一组同类的 Pod 总是可用的。

这个示例 ReplicationController 配置运行 nginx Web 服务器的 1 个副本。
```
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx-controller
spec:
  replicas: 1
  selector:
    name: nginx
  template:
    metadata:
      labels:
        name: nginx
    spec:
      containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80
```

## 2 - 创建 nginx-svc.yaml
Service 在 Kubernetes 中是一个 REST 对象，和 Pod 类似。 像所有的 REST 对象一样，Service 定义可以基于 POST 方式，请求 API server 创建新的实例。

默认情况下，Pod 只能通过 Kubernetes 集群中的内部 IP 地址访问。要使得 Nginx 容器可以从 Kubernetes 虚拟网络的外部访问，必须将 Pod 暴露为 Kubernetes Service。

Nginx 对外暴露了 80 端口，同时还被打上 name=nginx 标签。
```
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  ports:
    - protocol: TCP
      port: 8000
      targetPort: 80
  type: NodePort
  selector:
    name: nginx
```
上述配置创建一个名称为 "nginx-service" 的 Service 对象，它会将请求代理到使用 TCP 端口 80，并且具有标签 "name=nginx" 的 Pod 上。 Kubernetes 为该服务分配一个 IP 地址（有时称为 "集群IP"），该 IP 地址由服务代理使用。

需要注意的是，Service 能够将一个接收 port 映射到任意的 targetPort。 默认情况下，targetPort 将被设置为与 port 字段相同的值。

## 3 - 创建 Pod
```bash
# kubectl create -f ./nginx-rc.yaml
replicationcontroller/nginx-controller created
```

## 4 - 创建 Service
```bash
# kubectl create -f ./nginx-svc.yaml 
service/nginx-service created
```

## 5 - 查看 Pod
```bash
# kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
nginx-controller-nw8bj   1/1     Running   0          37s
```
```bash
# kubectl describe pods nginx-controller-nw8bj
Name:         nginx-controller-nw8bj
Namespace:    default
Priority:     0
Node:         bigdata-01.test.com/192.168.219.128
Start Time:   Thu, 17 Sep 2020 04:18:45 +0800
Labels:       app=nginx
Annotations:  cni.projectcalico.org/podIP: 192.168.81.207/32
              cni.projectcalico.org/podIPs: 192.168.81.207/32
Status:       Running
IP:           192.168.81.207
IPs:
  IP:           192.168.81.207
Controlled By:  ReplicationController/nginx-controller
Containers:
  nginx:
    Container ID:   docker://3f4f66c01b667fc690c5443500dac6e3d513c5ab0416f8715802a26cd0457e56
    Image:          nginx
    Image ID:       docker-pullable://nginx@sha256:c628b67d21744fce822d22fdcc0389f6bd763daac23a6b77147d0712ea7102d0
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 17 Sep 2020 04:18:49 +0800
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-ddskt (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  default-token-ddskt:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-ddskt
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age   From                          Message
  ----    ------     ----  ----                          -------
  Normal  Scheduled  74s   default-scheduler             Successfully assigned default/nginx-controller-nw8bj to bigdata-01.test.com
  Normal  Pulling    74s   kubelet, bigdata-01.test.com  Pulling image "nginx"
  Normal  Pulled     70s   kubelet, bigdata-01.test.com  Successfully pulled image "nginx"
  Normal  Created    70s   kubelet, bigdata-01.test.com  Created container nginx
  Normal  Started    70s   kubelet, bigdata-01.test.com  Started container nginx
```

## 6 - 查看 Service
```bash
# kubectl get svc
NAME            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
kubernetes      ClusterIP   192.168.0.1      <none>        443/TCP          39m
nginx-service   NodePort    192.168.59.168   <none>        8000:31610/TCP   10s
```
```bash
# kubectl describe service nginx-service
Name:                     nginx-service
Namespace:                default
Labels:                   <none>
Annotations:              <none>
Selector:                 name=nginx
Type:                     NodePort
IP:                       192.168.59.168
Port:                     <unset>  8000/TCP
TargetPort:               80/TCP
NodePort:                 <unset>  31610/TCP
Endpoints:                192.168.81.207:80
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```

## 7 - 测试 Nginx
```bash
浏览器窗口访问（主机 IP + 端口）：
http://192.168.219.128:31610
Welcome to nginx!
```

