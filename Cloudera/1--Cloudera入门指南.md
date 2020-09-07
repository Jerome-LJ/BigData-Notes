
## 1 - Cloudera Manager 简介
Cloudera Manager 是一个拥有集群自动化安装、中心化管理、集群监控、报警功能的管理工具。

Cloudera Manager 是用于管理 CDH 群集的端到端应用程序。Cloudera Manager 对 CDH 的每个组件都提供了细粒度的可视化和控制，从而设立了企业部署的标准。通过 Cloudera Manger，运维人员得以提高集群的性能，提升服务质量，提高合规性并降低管理成本。

Cloudera Manager 设计的目的是为了使得对于企业数据中心的管理变得简单和直观。通过 Cloudera Manager，可以方便地部署，并且集中式的操作完整的大数据软件栈。该应用软件会自动化安装过程，从而减少了部署集群的时间。通过 Cloudera Manager 可以提供一个集群范围内的节点实时运行状态视图。同时，还提供了一个中央控制台，可以用于配置集群。不仅如此，Cloudera Manager 包含一系列的报告和诊断工具，可以帮助我们优化集群性能，并提高利用率。

**Cloudera Manager 提供以下 4 大功能：**
- **1、管理：** 对集群进行管理，如添加、删除节点等操作。
- **2、监控：** 监控集群的健康情况，对设置的各种指标和系统运行情况进行全面监控。
- **3、诊断：** 对集群出现的问题进行诊断，对出现的问题给出建议解决方案。
- **4、集成：** 多组件进行整合。

## 2、Terminology（术语）
为了更好的使用 Cloudera Manager，我们需要先了解它的一些术语。术语之间的关系如下图所示，其定义如下：

# cm-model.jpg

## 3、Architecture（架构）
如下所示，Cloudera Manager 的核心是 Cloudera Manager Server。该服务器承载管理控制台的 Web 服务器和应用程序逻辑，并负责安装软件，配置，启动和停止服务，以及管理在其上的服务运行的群集。

# cm-architecture.png

Cloudera Manager Server 由以下几个部分组成：
- **Agent：** 安装在每台主机上。该代理负责启动和停止的过程，拆包配置，触发装置和监控主机。
- **[Management Service](https://docs.cloudera.com/documentation/enterprise/5-14-x/topics/cm_intro_primer.html#concept_fnf_mss_vk)：** 由一组执行各种监控，警报和报告功能角色的服务。
- **Database：** 存储配置和监视信息。通常情况下，多个逻辑数据库在一个或多个数据库服务器上运行。例如，Cloudera Manager Server 和监控角色使用不同的逻辑数据库。
- **Cloudera Repository：** 软件由 Cloudera Manager 分布存储库。
- **Clients：** 是用于与服务器进行交互的接口：
    - **[Admin Console](https://docs.cloudera.com/documentation/enterprise/5-14-x/topics/cm_intro_admin_console.html#cmug_topic_3_2)：** 基于 Web 的用户界面与管理员管理集群和 Cloudera 管理。
    - **[API](https://docs.cloudera.com/documentation/enterprise/5-14-x/topics/cm_intro_api.html#xd_583c10bfdbd326ba--7f25092b-13fba2465e5--7f20)：** 与开发人员创建自定义的 Cloudera Manager 应用程序的 API。


Heartbeating（心跳）是 Cloudera Manager 中的主要通信机制。默认情况下，Agent 每 15 秒发送一次心跳到 Cloudera Manager Server。当然，这个心跳频率可以进行调整。

通过这个心跳机制，Agent 向 Cloudera Manager Server 汇报自己的活动。反过来，Cloudera Manager Server 会响应 Agent 应执行的操作。Agent 和 Cloudera Manager Server 最终都会进行一些协调。例如，如果我们启动一个服务， Agent 尝试启动相应的进程，如果这个进程启动失败，则 Cloudera Manager Server 会将这个启动命令标记为失败。

## 4、State Management（状态管理）
Cloudera Manager Server 维护集群的状态。此状态可以分为两类：`model` 和 `runtime`，两者都存储在 Cloudera Manager Server 的数据库中。

# cm-state.png

Cloudera Manager 为 CDH 建模和托管服务：它们的角色、配置和内部依赖。模型状态捕获应该在哪里运行以及在什么配置下运行。例如，模型状态捕获了一个事实，即一个集群包含 17 个主机，每个主机都应该运行一个 DataNode。我们可以通过 Cloudera Manager 管理控制台配置页，或者 API 来操作与模型进行交互，例如，**"Add Service"**。

`Runtime` 状态是当前在何处运行哪些进程以及正在运行哪些命令（例如，重新平衡 HDFS 或运行备份/灾难恢复计划或滚动重启或停止）。运行时状态包括运行进程所需的确切配置文件。当我们在 Cloudera Manager 管理控制台中选择 `“Start”` 时，服务器将收集相关服务和角色的所有配置，对其进行验证，生成配置文件，并将其存储在数据库中。

当更新配置（例如，Hue Server Web 端口）时，我们已经更新了模型状态。但是，如果在执行此操作时 Hue 正在运行，则它仍在使用旧端口。当发生这种不匹配时，该角色被标记为具有 `"outdated configuration（过时的配置）"`。需要重新同步，我们必须重启角色（这将触发重新生成配置以及重新启动进程）。

尽管 Cloudera Manager 为所有合理的配置建模，但某些情况下不可避免地需要特殊处理。为了允许我们解决问题（例如错误）或探究不支持的选项，Cloudera Manager 支持 ["advanced configuration snippet"](https://docs.cloudera.com/documentation/enterprise/5-14-x/topics/cm_mc_config_snippet.html#xd_583c10bfdbd326ba--43d5fd93-1410993f8c2--7ea7)（高级配置代码段）机制，该机制可让我们直接将属性添加到配置文件中。

## 5、Configuration Management（配置管理）
## 6、Process Management（进程管理）
## 7、Software Distribution Management（软件发行管理）
## 8、Host Management（主机管理）
## 9、Resource Management（资源管理）
## 10、User Management（用户管理）
## 11、Security Management（安全管理）
## 12、Cloudera Management Service（Cloudera 管理服务）





















