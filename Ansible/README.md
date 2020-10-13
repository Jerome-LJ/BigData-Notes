# BigData Ansible Playbook
大数据自动化安装脚本汇总。

---

<nav>
<a href="#使用示例"</a>使用示例</a><br/>
<a href="#1---java7java8java11-自动化安装脚本"</a>1 - Java7/Java8/Java11 自动化安装脚本</a><br/>
<a href="#2---supervisor-自动化安装脚本"</a>2 - Supervisor 自动化安装脚本</a><br/>
<a href="#3---flume-自动化安装脚本"</a>3 - Flume 自动化安装脚本</a><br/>
</nav>

---

## 使用示例
```bash
#【1】克隆下载
$ git clone https://github.com/Jerome-LJ/BigData-Notes.git
$ cd BigData-Notes/Ansible
#【2】根据实际情况，自行修改参数变量（例如：install_jdk.yml 文件、hosts 文件）
$ cat install_jdk.yml
  roles:
    # java7=jdk1.7，java8=jdk1.8，java11=jdk11
    - { role: install_jdk, jdk_type: "java7" }
#【3】执行脚本
$ ansible-playbook -i hosts -e host_list=test install_jdk.yml -k
```

## 1 - Java7/Java8/Java11 自动化安装脚本
```bash
$ ansible-playbook -i hosts -e host_list=test install_jdk.yml -k
```

## 2 - Supervisor 自动化安装脚本
```bash
$ ansible-playbook -i hosts -e host_list=test install_supervisor.yml -k
#启动 Supervisor
$ supervisord -c /opt/bigdata/supervisor/supervisord.conf
#进入 Supervisor，查看被管理的 program
$ supervisorctl -c /opt/bigdata/supervisor/supervisord.conf
```

## 3 - Flume 自动化安装脚本
```bash
$ ansible-playbook -i hosts -e host_list=test install_flume.yml -k
```
