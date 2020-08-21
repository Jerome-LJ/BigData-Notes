<nav>
<a href="#1---kafka-基本概念">1 - Kafka 基本概念</a><br/>
<a href="#2---kafka-角色术语">2 - Kafka 角色术语</a><br/>
<a href="#3---kafka-架构概述">3 - Kafka 架构概述</a><br/>
<a href="#4---messages-与-batches">4 - Messages 与 Batches</a><br/>
<a href="#5---topic-与-partition">5 - Topic 与 Partition</a><br/>
<a href="#6---producer-生产机制">6 - Producer 生产机制</a><br/>
<a href="#7---consumer-消费机制">7 - Consumer 消费机制</a><br/>
<a href="#8---brokers-与-clusters">8 - Brokers 与 Clusters</a><br/>
</nav>

---

## 1 - Kafka 基本概念
Kafka 是一个高吞吐量的分布式发布/订阅消息系统。现在是个大数据时代，各种商业、社交、搜索、浏览都会产生大量的数据。那么如何快速收集这些数据，如何实时的分析这些数据，是一个必须要解决的问题，同时，这也形成了一个业务需求模型，即生产者生产（Produce）各种数据、消费者（Consume）消费（分析、处理）这些数据。那么面对这些需求，如何高效、稳定的完成数据的生产和消费呢？这就需要在生产者与消费者之间，建立一个通信的桥梁，这个桥梁就是**消息系统**。从微观层面来说，这种业务需求也可理解为不同的系统之间如何传递消息。

Kafka 是 Apache 组织下的一个开源系统，它的最大特性就是可以实时的处理大量数据以满足各种需求场景：比如基于 Hadoop 平台的数据分析、低时延的实时系统、Storm/Spark/Flink 流式处理引擎等。Kafka 现在已被多家大型公司作为多种类型的数据管道和消息系统使用。

Kafka 是一个高吞吐量的分布式发布/订阅消息系统。特点如下：
- 支持消息的发布和订阅，类似于 RabbtMQ、ActiveMQ 等消息队列；
- 支持数据实时处理；
- 可靠性，能保证消息的可靠性传递；
- 消息持久化，并通过多副本分布式的存储方案来保证消息的容错；
- 扩展性，支持对大规模数据的处理，进行水平扩展集群；
- 高吞吐率，单 Broker 可以轻松处理数千个分区以及每秒百万级的消息量；
- 多客户端支持，提供多种开发语言的接入。

## 2 - Kafka 角色术语
在介绍架构之前，先来了解下 Kafka 中的一些核心概念和各种角色。
- Broker：Kafka 集群包含一个或多个服务器，每个服务器被称为 Broker。
- Topic（主题）：每条发布到 Kafka 集群的消息都有一个分类，这个类别被称为 Topic（主题）。
- Producer（生产者）：负责发布消息到 Kafka Broker。
- Consumer（消费者）：从 Kafka Broker 拉取数据，并消费这些已发布的消息。
- Partition（分区）：为了实现扩展性，提高并发能力，每个 Topic 包含一个或多个 Partition，每个 Partition 都是一个有序的队列。Partition 中的每条消息都会被分配一个有序的 ID（称为 Offset）。
- Consumer Group（消费者组）：可以给每个 Consumer 指定消费者组，若不指定，则属于默认的 Group。
- Message（消息）：通信的基本单位，每个 Producer 可以向一个 Topic 发布一些消息。
- Replica（副本）：为实现备份的功能，保证集群中的某个节点发生故障时，该节点上的 Partition 数据不丢失，且 Kafka 仍然能够继续工作，Kafka 提供了副本机制，一个 Topic 的每个分区都有若干个副本，一个 Leader 和若干个Follower。
- Leader（领导）：每个分区多个副本的<主>副本，生产者发送数据的对象，以及消费者消费数据的对象，都是 Leader。
- Follower（追随者）：每个分区多个副本的<从>副本，实时从 Leader 中同步数据，保持和 Leader 数据的同步。Leader 发生故障时，某个 Follower 通过 Controller 选举成为新的 Leader。
- Controller（控制器）：Kafka 使用 zk 在 broker 中选出一个 Controller，用于 partition 分配和 leader 选举。
- Offset（偏移量）：消费者消费的位置偏移量，当消费者挂掉再重新恢复的时候，可以从消费位置继续消费。
- ZooKeeper（管理员）：帮助 Kafka 存储和管理集群信息。

## 3 - Kafka 架构概述
一个典型的 Kafka 集群包含若干 Producer、Broker、Consumer Group，以及一个 ZooKeeper 集群。Kafka 通过 ZooKeeper 管理集群配置，选举 Leader，以及在 Consumer Group 发生变化时进行 Rebalance。Producer 使用 push 模式将消息发布到 Broker，Consumer 使用 pull 模式从 Broker 订阅并消费消息。典型架构图如下图所示：

<div align="center"> <img width="700px" src="../images/Kafka/kafka典型架构图.png"/> </div>

从图中可以看出，典型的消息系统由生产者（Producer）、存储系统（Broker）和消费者（Consumer）组成。Kafka 作为分布式的消息系统支持多个生产者和消费者，生产者可以将消息分布到集群中不同节点的不同 Partition 上，消费者也可以消费集群中多个节点上的多个 Partition。在写消息时允许多个生产者写到同一个 Partition 中，但是读消息时一个 Partition 只允许被一个消费组中的一个消费者所消费，而一个消费者可以消费多个 Partition。也就是说同一个消费组下消费者对 Partition 是互斥的，而不同消费组之间是共享的。

Kafka 中的 Producer 和 Consumer 采用的是 push（推送）、pull（拉取）的模式，即 Producer 只是向 Broker push 消息，Consumer 只是从 Broker pull 消息，push 和 pull 对于消息的生产和消费是异步进行的。pull 模式的一个好处是 Consumer 可自主控制消费消息的速率，同时 Consumer 还可以自己控制消费消息的方式是批量地从 Broker 拉取数据还是逐条消费数据。

Kafka 支持消息持久化存储，持久化数据保存在 Kafka 的日志文件中，在生产者生产消息后，Kafka 不会直接把消息传递给消费者，而是先要在 Broker 中进行存储。为了减少磁盘写入的次数，Broker 会将消息暂时缓存起来，当消息的个数或批次时间、大小达到一定阈值时，再统一写到磁盘上。这样不但提高了 Kafka 的执行效率，也减少了磁盘 IO 调用次数。

Kafka 中每条消息写到 Partition 中时，是顺序写入磁盘的，这个很重要。因为在机械盘中如果是随机写入的话，效率将很低，但如果顺序写入，那么效率却非常高。这种顺序写入磁盘机制是 Kafka 高吞吐率的一个很重要的保证。

## 4 - Messages 与 Batches
Kafka 的基本数据单元被称为 message(消息)，为减少网络开销，提高效率，多个消息会被放入同一批次 (Batch) 中后再写入，配置参数 `max.message.bytes`。

## 5 - Topic 与 Partition
Kafka 中的 Topic 是以 Partition 的形式存放的，每一个 Topic 都可以设置它的 Partition 数量，该数量决定了组成 Topic 的 Log 的数量。推荐 Partition 的数量一定要大于同时运行的 Consumer 数量。另外，建议 Partition 的数量大于集群 Broker 的数量，这样消息数据就可以均匀地分布在各个 Broker 中了。

那么，Topic 为什么要设置多个 Partition 呢？这是因为 Kafka 是基于文件存储的，通过配置多个 Partition 可以将消息内容分散存储到多个 Broker 上，这样可以避免文件大小达到单机磁盘的上限。同时，将一个 Topic 切分成任意多个 Partitions，可以保证消息存储、消息消费的效率，因为越多的 Partitions 可以容纳更多的 Consumer，可有效提升 Kafka 的吞吐率。因此，将 Topic 切分成多个 Partitions 的好处是可以将大量的消息分成多批数据同时写到不同节点上，将写请求分担负载到各个集群节点。

在存储结构上，每个 Partition 在物理上对应一个文件夹，该文件夹下存储这个 Partition 的所有消息和索引文件。Partiton 命名规则为 Topic 名称 + 序号，第一个 Partiton 序号从 0 开始，序号最大值为 Partitions 数量减 1。由于一个 Topic 包含多个分区，因此无法在整个 Topic 范围内保证消息的顺序性，但可以保证消息在单个分区内的顺序性。

<div align="center"> <img src="../images/Kafka/log_anatomy.png"/> </div>

在每个 Partition（文件夹）中有多个大小相等的 Segment（段）数据文件，每个 Segment 的大小是相同的，但每条消息的大小可能不相同。因此 Segment 数据文件中消息数量不一定相等。Segment 数据文件有两个部分组成：index file 和 data file，此两个文件一一对应，成对出现，后缀`.index`和`.log`分别表示为 Segment 索引文件和数据文件。

## 6 - Producer 生产机制
Producer 是消息和数据的生产者，当它发送消息到 Broker 时，会根据 Paritition 机制选择将其存储到哪一个 Partition。如果 Partition 机制设置的合理，所有消息都可以均匀分布到不同的 Partition 里，这样就实现了数据的负载均衡。如果一个 Topic 对应一个文件，那这个文件所在的机器 I/O 将会成为这个 Topic 的性能瓶颈；而有了 Partition 后，不同的消息可以并行写入不同 Broker 的不同 Partition 里，极大地提高了吞吐率。

为了保证 Producer 发送的数据，能可靠的发送到指定的 Topic，Topic 的每个 Partition 收到 Producer 发送的数据后，都需要向 Producer 发送 ACK（ACKnowledge 确认收到）。如果 Producer 收到 ACK，就会进行下一轮的发送，否则重新发送数据。

ACK 参数配置：
- 0：Producer 不等待 Broker 的 ACK，这提供了最低延迟，Broker 一收到数据还没有写入磁盘就已经返回，当 Broker 故障时有可能丢失数据。
- 1：Producer 等待 Broker 的 ACK，Partition 的 Leader 落盘成功后返回 ACK，如果在 Follower 同步成功之前 Leader 故障，那么将会丢失数据。
- -1（all）：Producer 等待 Broker 的 ACK，Partition 的 Leader 和 Follower 全部落盘成功后才返回 ACK。但是在 Broker 发送 ACK 时，Leader 发生故障，则会造成数据重复。

如果设置为（-1），等到所有 Follower 完成同步，Producer 才能继续发送数据，设想有一个 Follower 因为某种原因出现故障，那 Leader 就要一直等到它完成同步。

**这个问题怎么解决？**

Leader 维护了一个动态的 in-sync replica set（ISR）：和 Leader 保持同步的 Follower 集合。当 ISR 集合中的 Follower 完成数据的同步之后，Leader 就会给 Follower 发送 ACK。

如果 Follower 长时间未向 Leader 同步数据，则该 Follower 将被踢出 ISR 集合，该时间阈值由 `replica.lag.time.max.ms` 参数设定。Leader 发生故障后，就会从 ISR 中选举出新的 Leader。

<div align="center"> <img src="../images/Kafka/kafka_hw.png"/> </div>

- LEO：每个副本最大的 Offset
- HW：消费者能见到的最大的 Offset，ISR 队列中最小的 LEO。

Follower 故障：Follower 发生故障后会被临时踢出 ISR 集合，待该 Follower 恢复后，Follower 会 读取本地磁盘记录的上次的 HW，并将 log 文件高于 HW 的部分截取掉，从 HW 开始向 Leader 进行同步数据操作。

等该 Follower 的 LEO 大于等于该 Partition 的 HW，即 Follower 追上 Leader 后，就可以重新加入 ISR 了。

Leader 故障：Leader 发生故障后，会从 ISR 中选出一个新的 Leader，之后，为保证多个副本之间的数据一致性，其余的 Follower 会先将各自的 log 文件高于 HW 的部分截掉，然后从新的 Leader 同步数据。

注意：这只能保证副本之间的数据一致性，并不能保证数据不丢失或者不重复。

## 7 - Consumer 消费机制
Kafka 发布消息通常有两种模式：**队列模式（Queuing）和发布/订阅模式（Publish-Subscribe）**。
- 在队列模式（类似MQ）下，只有一个消费组，而这个消费组有多个消费者，一条消息只能被这个消费组中的一个消费者所消费。
- 在发布/订阅模式（一对多）下，可以有多个消费组，但每个消费组只有一个消费者，同一条消息可被多个消费组消费。

消费者按照消息生成的顺序来读取，并通过检查消息的偏移量（offset）来区分读取过的消息。偏移量是一个不断递增的数值，在创建消息时，Kafka 会把它添加到其中，在给定的分区里，每个消息的偏移量都是唯一的。消费者把每个分区最后读取的偏移量保存在 Zookeeper 或 Kafka 上，如果消费者关闭或者重启，它还可以重新获取该偏移量，以保证读取状态不会丢失。

<div align="center"> <img src="../images/Kafka/log_consumer.png"/> </div>

一个分区只能被同一个消费者组里面的一个消费者读取，但可以被不同消费者群组中所组成的多个消费者共同读取。多个消费者群组中消费者共同读取同一个主题时，彼此之间互不影响。

<div align="center"> <img src="../images/Kafka/consumer-groups.png"/> </div>

## 8 - Brokers 与 Clusters
一个独立的 Kafka 服务器被称为 Broker。Broker 接收来自生产者的消息，为消息设置偏移量，并提交消息到磁盘保存。Broker 为消费者提供服务，对读取分区的请求做出响应，返回已经提交到磁盘的消息。

Broker 是集群 Cluster 的组成部分。每一个集群都会选举出一个 Broker 作为集群控制器（Controller），集群控制器负责管理工作，包括将分区分配给 Broker 和监控 Broker。

在集群中，一个 Partition 从属于一个 Broker，该 Broker 被称为分区的 Leader。一个分区可以分配给多个 Brokers，这个时候会发生分区复制。这种复制机制为分区提供了消息冗余，如果其中一个 Broker 故障，其它 Broker 可以接管领导权。

<div align="center"> <img src="../images/Kafka/kafka架构图.png"/> </div>
