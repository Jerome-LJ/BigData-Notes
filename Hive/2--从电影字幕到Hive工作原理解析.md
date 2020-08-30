> 以下文章来源于公众号[《互联网侦察》](https://mp.weixin.qq.com/s/xyP5ILcITtiwrKtXFsMenw) ，作者 channingbreeze。

<div align="center"> <img src="../images/hive/pictures/000.png"/> </div>

小史是一个非科班的程序员，虽然学的是电子专业，但是通过自己的努力成功通过了面试，现在要开始迎接新生活了。

<div align="center"> <img src="../images/hive/pictures/001.png"/> </div>

找到工作到正式上班之间的这段时间总是惬意的，小史决定利用这段时间把一些经典电影重温一下。

<div align="center"> <img src="../images/hive/pictures/002.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/003.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/004.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/005.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/006.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/007.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/008.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/009.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/010.png"/> </div>

**【 Hive 简介】**

<div align="center"> <img src="../images/hive/pictures/011.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/012.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/013.png"/> </div>

吕老师：这就要说到之前提到的 OLTP 和 OLAP 的概念了，数据仓库是用来做 OLAP 的，注重查询分析。并且数据仓库的数据量一般比数据库要大一个数量级。

<div align="center"> <img src="../images/hive/pictures/014.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/015.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/016.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/017.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/018.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/019.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/020.png"/> </div>

**【 Hive 工作原理】**

<div align="center"> <img src="../images/hive/pictures/021.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/022.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/023.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/024.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/025.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/026.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/027.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/028.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/029.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/030.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/031.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/032.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/033.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/034.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/035.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/036.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/037.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/038.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/039.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/040.png"/> </div>

**【数据迁移 sqoop 】**

<div align="center"> <img src="../images/hive/pictures/041.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/042.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/043.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/044.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/045.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/046.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/047.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/048.png"/> </div>

**【 Hive 优缺点】**

<div align="center"> <img src="../images/hive/pictures/049.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/050.png"/> </div>

小史：嗯，刚刚我就一直在思考这个问题了， Hive 的优点很明显，它提供了一种 SQL 的方式查询大数据，上手简单，减少了开发人员的学习成本。

<div align="center"> <img src="../images/hive/pictures/051.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/052.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/053.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/054.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/055.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/056.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/057.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/058.png"/> </div>

<div align="center"> <img src="../images/hive/pictures/059.png"/> </div>

**【笔记】**

在下载电影的过程中，小史顺便记下了今天的笔记。

1、Hive 是一个数据仓库，存储大数据，主要用来做 OLAP 分析。

2、Hive 底层是hdfs，它提供了 SQL 来查询数据。

3、Hive 的原理是将 SQL 翻译成 map-reduce 任务。

4、数据的导入导出可以用工具 sqoop，原理也是把命令翻译成 map-reduce 任务。

> 作者：channingbreeze
> 
> 编辑：陶家龙、孙淑娟
> 
> 出处：转载自微信公众号：《互联网侦察》
