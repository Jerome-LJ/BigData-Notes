
## 1 - Spark 简介
Apache Spark 是一个基于内存的分布式计算引擎。在迭代计算的场景下，数据处理过程中的数据可以存储在内存中，提供了比 MapReduce 高 10 到 100 倍的计算能力。Spark 可以使用 HDFS 作为底层存储，使用户能够快速的从 MapReduce 切换到 Spark 计算平台上去。Spark 提供一站式数据分析能力，包括小批量流式处理、离线批处理、SQL 查询、数据挖掘等，用户可以在同一个应用中无缝结合使用这些能力。

Spark 四大组件包括：Spark SQL、Spark Streaming、MLlib、GraphX。为此提供了强大的支持，也都是建立在 Spark 核心引擎之上：

<div align="center"> <img src="../images/spark/spark-stack.png"/> </div>

**Spark 的特点如下：**
- **运行速度快：** 通过分布式内存计算和 DAG（有向无环图）执行引擎提升数据处理能力，比 MapReduce 性能高 10 倍到 100 倍。
- **易于使用：** 支持使用 Scala、Java、Python 和 R 语言的高级 API 进行编程，可以很方便构建分布式的数据处理应用。
- **通用性：** 结合 SQL 查询、Streaming（流式计算）、MLlib（机器学习）、GraphX（图算法）等形成数据处理栈，提供一站式数据处理能力。
- **运行模式多样：** 可运行于独立的集群模式中，完美契合 Hadoop 生态环境，Spark 应用可以运行在 Standalone、Mesos、Kubernetes 或者 YARN 上，能够接入 HDFS、HBase、Hive 等多种数据源，支持 MapReduce 程序平滑转接。

## 2 - 角色术语
**1、Cluster Manager**

Spark 的集群管理器，主要负责整个集群资源的分配与管理。支持多种集群管理器，Cluster Manager 部署在不同模式下对应的角色也不一样：
- 在 Hadoop Yarn 部署模式下为 ResourceManager。
- 在 Mesos 部署模式下为 Mesos Master。
- 在 Standalone 部署模式下为 Master。

Cluster Manager 分配的资源属于一级分配，它将各个 Worker 上的内存、CPU 等资源分配给 Application，但是并不负责对 Executor 的资源分配。Standalone 部署模式下的 Master 会直接给 Application 分配内存、CPU 及 Executor 等资源。目前，Standalone、Yarn、Mesos、EC2 等都可以作为 Spark 的集群管理器。

**2、Worker Node**

Worker Node 是 Spark 的工作节点，在 Yarn 部署模式下实际由 NodeManager 替代。Worker Node 主要负责以下工作：
- 将自己的内存、CPU 等资源通过注册机制告知 Cluster Manager；
- 创建 Executor，将资源和任务进一步分配给 Executor；
- 同步资源信息、Executor 状态信息给 Cluster Manager。
- 在独立部署模式下，Master 将 Worker 上的内存、CPU 及 Executor 等资源分配给 Application 后，将命令 Worker Node 启动 `CoarseGrainedExecutorBackend` 进程（此进程会创建 Executor 实例）。

**3、Executor**

Executor 是 Spark 任务（Task）的执行单元，是在 Worker Node 上启动的进程用来执行 Task。实际上它是一组计算资源（Memory、CPU）的集合。一个 Worker Node 上的 Memory、CPU 由多个 Executor 共同分摊。同时，Executor 还负责与 Worker、Driver 的信息同步、接收 Driver 命令，并执行一个或多个 Task。其实这个 Executor 跟 Yarn 资源管理器中的 Container 实现的功能类似。

**4、Driver Program**

Driver Program 是 Spark 应用程序 Application 的主进程。运行 Application 的 `main()` 函数并创建 `SparkContext`。负责应用程序的解析、生成 Stage 并调度 Task 到 Executor 上。通常 SparkContext 代表 Driver Program。Driver Program 可以运行在 Application 中，也可以由 Application 提交给 Cluster Manager，并由 Cluster Manager 安排在 Worker Node 中运行。

**5、Application**

用户使用 Spark 提供的 API 编写的应用程序，由一个 Driver Program 和多个 Executor 组成。Application 通过 Spark API 将进行 RDD 的转换和 DAG 的构建，并通过 Driver 将 Application 注册到 Cluster Manager。Cluster Manager 将会根据 Application 的资源需求，通过一级分配将 Executor、内存、CPU 等资源分配给 Application。Driver Program 通过二级分配将 Executor 等资源分配给每一个任务，Application 最后通过 Driver Program 告诉 Executor 运行任务。

**6、Deploy Mode**

部署模式，分为 Cluster 和 Client 模式。Cluster 模式下，Driver Program 会在集群内的节点运行；而在 Client 模式下，Driver Program 在客户端运行（集群外）。

**7、Job**

一个 Action 算子（比如 collect 算子）对应一个 Job，由并行计算的多个 Task 组成。
 
**8、Stage**

每个 Job 由多个 Stage 组成，每个 Stage 是一个 Task 集合，由 DAG 分割而成。
 
**9、Task**

是 Spark 平台中可执行的最小工作单元。一个应用根据执行计划以及计算量分为多个 Task。是 Executor 中的一个线程。

## 3 - Spark 架构设计
Spark 集群由集群管理器（Cluster Manager）、工作节点（Worker Node）、执行器（Executor）、驱动器（Driver）、应用程序（Application）等部分组成。对于每个 Spark 应用程序，Worker Node 上存在一个 Executor 进程，Executor 进程中包括多个 Task 线程，其整体关系如下图所示：

<div align="center"> <img src="../images/spark/spark-architecture.png"/> </div>

## 4 - Spark 运行流程

## 5 - RDD 数据结构

## 6 - Spark 适用场景
Spark 是分布式计算引擎，提供分析挖掘与迭代式内存计算能力，支持多种语言（Scala/Java/Python/R）的应用开发。适用以下场景：

- 1、**数据处理（Data Processing）：** 可以用来快速处理数据，兼具容错性和可扩展性。
- 2、**迭代计算（Iterative Computation）：** 支持迭代计算，有效应对多步的数据处理逻辑。
- 3、**数据挖掘（Data Mining）：** 在海量数据基础上进行复杂的挖掘分析，可支持各种数据挖掘和机器学习算法。
- 4、**流式处理（Streaming Processing）：** 支持秒级延迟的流式处理，可支持多种外部数据源。
- 5、**查询分析（Query Analysis）：** 支持标准 SQL 查询分析，同时提供 DSL（DataFrame），并支持多种外部输入。

## 7 - WordCount范例
