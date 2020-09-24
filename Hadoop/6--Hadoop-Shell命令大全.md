<nav>
<a href="#1---hadoop-shell-命令简介">1 - Hadoop Shell 命令简介</a><br/>
<a href="#2---appendtofile">2 - appendToFile</a><br/>
<a href="#3---cat">3 - cat</a><br/>
<a href="#4---checksum">4 - checksum</a><br/>
<a href="#5---chgrp">5 - chgrp</a><br/>
<a href="#6---chmod">6 - chmod</a><br/>
<a href="#7---chown">7 - chown</a><br/>
<a href="#8---copyfromlocal">8 - copyFromLocal</a><br/>
<a href="#9---copytolocal">9 - copyToLocal</a><br/>
<a href="#10---count">10 - count</a><br/>
<a href="#11---cp">11 - cp</a><br/>
<a href="#12---createsnapshot">12 - createSnapshot</a><br/>
<a href="#13---renamesnapshot">13 - renameSnapshot</a><br/>
<a href="#14---deletesnapshot">14 - deleteSnapshot</a><br/>
<a href="#15---df">15 - df</a><br/>
<a href="#16---du">16 - du</a><br/>
<a href="#17---dus">17 - dus</a><br/>
<a href="#18---expunge">18 - expunge</a><br/>
<a href="#19---find">19 - find</a><br/>
<a href="#20---get">20 - get</a><br/>
<a href="#21---getfacl">21 - getfacl</a><br/>
<a href="#22---setfacl">22 - setfacl</a><br/>
<a href="#23---getfattr">23 - getfattr</a><br/>
<a href="#24---setfattr">24 - setfattr</a><br/>
<a href="#25---getmerge">25 - getmerge</a><br/>
<a href="#26---head">26 - head</a><br/>
<a href="#27---help">27 - help</a><br/>
<a href="#28---ls">28 - ls</a><br/>
<a href="#29---lsr">29 - lsr</a><br/>
<a href="#30---mkdir">30 - mkdir</a><br/>
<a href="#31---movefromlocal">31 - moveFromLocal</a><br/>
<a href="#32---movetolocal">32 - moveToLocal</a><br/>
<a href="#33---mv">33 - mv</a><br/>
<a href="#34---put">34 - put</a><br/>
<a href="#35---rm">35 - rm</a><br/>
<a href="#36---rmdir">36 - rmdir</a><br/>
<a href="#37---rmr">37 - rmr</a><br/>
<a href="#38---setrep">38 - setrep</a><br/>
<a href="#39---stat">39 - stat</a><br/>
<a href="#40---tail">40 - tail</a><br/>
<a href="#41---test">41 - test</a><br/>
<a href="#42---text">42 - text</a><br/>
<a href="#43---touch">43 - touch</a><br/>
<a href="#44---touchz">44 - touchz</a><br/>
<a href="#45---truncate">45 - truncate</a><br/>
<a href="#46---usage">46 - usage</a><br/>
<a href="#47---distcp">47 - distcp</a><br/>
<a href="#48---dfsadmin">48 - dfsadmin</a><br/>
</nav>

---

## 1 - Hadoop Shell 命令简介
```bash
#可以用于任何文件系统，不止是 HDFS 文件系统内，也就是说该命令的使用范围更广
$ hadoop fs <args>

#只能用于 HDFS 分布式文件系统
$ hadoop dfs <args>

#和上面的命令作用相同，相比于上面的命令更为推荐，并且当使用 hadoop dfs 时内部会被转为 hdfs dfs 命令
$ hdfs dfs <args>
```

## 2 - appendToFile
**使用方法：**
```
hadoop fs -appendToFile <localsrc> ... <dst>
```
将本地文件系统中的单个文件或多个文件追加合并到目标文件系统。还可以从 `stdin` 读取输入，并将其追加到目标文件系统。

**示例：**
```bash
hadoop fs -appendToFile localfile /user/hadoop/hadoopfile
hadoop fs -appendToFile localfile1 localfile2 /user/hadoop/hadoopfile
hadoop fs -appendToFile localfile hdfs://nn.example.com/hadoop/hadoopfile
#从 stdin 中读取输入
hadoop fs -appendToFile - hdfs://nn.example.com/hadoop/hadoopfile
```
**返回值：**

成功返回0，失败返回1。

## 3 - cat
**使用方法：**
```
hadoop fs -cat [-ignoreCrc] URI [URI ...]
```
将路径指定文件的内容输出到 `stdout`。

**示例：**
```
hadoop fs -cat hdfs://nn1.example.com/file1 hdfs://nn2.example.com/file2
hadoop fs -cat file:///file3 /user/hadoop/file4
```
**返回值：**
成功返回0，失败返回-1。

## 4 - checksum
**使用方法：**
```
hadoop fs -checksum URI
```
返回文件的校验和信息。

**示例：**
```
hadoop fs -checksum hdfs://nn1.example.com/file1
hadoop fs -checksum file:///etc/hosts
```

## 5 - chgrp
**使用方法：**
```
hadoop fs -chgrp [-R] GROUP URI [URI ...]
```
修改文件的所属组。命令的使用者必须是文件的所有者或者超级用户。更多的信息请参见[权限指南](http://hadoop.apache.org/docs/r3.3.0/hadoop-project-dist/hadoop-hdfs/HdfsPermissionsGuide.html)

**参数**
- -R : 表示通过目录结构进行递归修改。

**示例：**
```
hadoop fs -chgrp -R supergroup /user/jerome
```

## 6 - chmod
**使用方法：**
```
hadoop fs -chmod [-R] <MODE[,MODE]... | OCTALMODE> URI [URI ...]
```
修改文件的权限。命令的使用者必须是文件的所有者或者超级用户。更多的信息请参见[权限指南](http://hadoop.apache.org/docs/r3.3.0/hadoop-project-dist/hadoop-hdfs/HdfsPermissionsGuide.html)

**参数：**
- -R : 表示通过目录结构进行递归修改。

**示例：**
```
hadoop fs -chmod -R 777 /user/jerome
```

## 7 - chown
**使用方法：**
```
hadoop fs -chown [-R] [OWNER][:[GROUP]] URI [URI ]
```
修改文件的拥有者。命令的使用者必须是超级用户。更多的信息请参见[权限指南](http://hadoop.apache.org/docs/r3.3.0/hadoop-project-dist/hadoop-hdfs/HdfsPermissionsGuide.html)

**参数：**
- -R : 表示通过目录结构进行递归修改。

**示例：**
```
hadoop fs -chown -R jerome:jerome /user/jerome
```

## 8 - copyFromLocal
**使用方法：**
```
hadoop fs -copyFromLocal <localsrc> URI
```
与 put 命令相似，仅能从本地复制到目标文件系统。

**参数：**
- -p : 保留访问和修改时间以及权限。
- -f : 如果目标文件已经存在，则将其覆盖。
- -l : 允许 DataNode 将文件延迟保存到磁盘，强制复制因子为 1。此参数将导致持久性降低。
- -d : 跳过后缀为 `._COPYING_.` 临时文件的创建。

**示例：**
```
hadoop fs -copyFromLocal file1 /user/jerome/
```

## 9 - copyToLocal
**使用方法：**
```
hadoop fs -copyToLocal [-ignorecrc] [-crc] URI <localdst>
```
与 get 命令类似，仅能从目标文件系统复制到本地。

**示例：**
```
hadoop fs -copyToLocal /user/jerome/file2 ./
```

## 10 - count
**使用方法：**
```
hadoop fs -count [-q] [-h] [-v] [-x] [-t [<storage type>]] [-u] [-e] <paths>
```
递归统计当前文件下的所有信息：数字代表（目录总数量、文件总数量、文件总大小信息）

**参数：**
- -u/-q : 控制输出包含哪些列。-q 显示每个目录设置的配额，以及剩余配额，-u 输出限制为仅显示配额和使用情况。
  - -q 输出的列是：QUOTA, REMAINING_QUOTA, SPACE_QUOTA, REMAINING_SPACE_QUOTA, DIR_COUNT, FILE_COUNT, CONTENT_SIZE, PATHNAME
  - -u 输出的列是：QUOTA, REMAINING_QUOTA, SPACE_QUOTA, REMAINING_SPACE_QUOTA, PATHNAME
- -t : 显示每种存储类型的配额和使用情况。
- -h : 格式化显示大小（例如 64.0M 表示 67108864）。
- -v : 显示标题行。
- -x : 从结果计算中排除快照。
- -e : 显示每个文件的纠删码码策略。
  - -e 输出的列是：DIR_COUNT, FILE_COUNT, CONTENT_SIZE, ERASURECODING_POLICY, PATHNAME
  - ERASURECODING_POLICY 是文件策略的名称。如果在该文件上设置了纠删码策略，它将返回该策略的名称。如果未设置纠删码策略，它将返回 “`已复制`”，这表示它使用复制存储策略。

**示例：**
```
hadoop fs -count hdfs://nn1.example.com/file1 hdfs://nn2.example.com/file2
hadoop fs -count -q hdfs://nn1.example.com/file1
hadoop fs -count -q -h hdfs://nn1.example.com/file1
hadoop fs -count -q -h -v hdfs://nn1.example.com/file1
hadoop fs -count -u hdfs://nn1.example.com/file1
hadoop fs -count -u -h hdfs://nn1.example.com/file1
hadoop fs -count -u -h -v hdfs://nn1.example.com/file1
hadoop fs -count -e hdfs://nn1.example.com/file1
```
**返回值：**

成功返回0，失败返回-1。

## 11 - cp
**使用方法：**
```
hadoop fs -cp [-f] [-p | -p[topax]] URI [URI ...] <dest>
```
将文件从源路径复制到目标路径。这个命令允许有多个源路径，此时目标路径必须是一个目录。

**参数：**
- -f : 如果目标文件已经存在，则覆盖。
- -p : 将保留文件属性[topx]（时间戳，所有权，权限，ACL，XAttr）

**示例：**
```
hadoop fs -cp /user/hadoop/file1 /user/hadoop/file2
hadoop fs -cp /user/hadoop/file1 /user/hadoop/file2 /user/hadoop/dir
```
**返回值：**

成功返回0，失败返回-1。

## 12 - createSnapshot
**使用方法：**
```
hdfs dfs -createSnapshot <path> [<snapshotName>]
```
创建快照目录的快照。此操作需要 snaphottable 目录的所有者特权。更多的信息请参见[HDFS 快照指南](http://hadoop.apache.org/docs/r3.3.0/hadoop-project-dist/hadoop-hdfs/HdfsSnapshots.html)

**参数：**
- path : snaphottable 目录的路径。
- snapshotName : 快照名称，它是一个可选参数。当省略时，使用格式为 `"'s'yyyyMMdd-HHmmss.SSS"` 的时间戳生成默认名称，例如 `"s20130412-151029.033"`。

**示例：**
```
hdfs dfs -createSnapshot /user/hadoop/jerome s1
Created snapshot /user/hadoop/jerome/.snapshot/s1
```

## 13 - renameSnapshot
**使用方法：**
```
hdfs dfs -renameSnapshot <path> <oldName> <newName>
```
重命名快照。此操作需要 snaphottable 目录的所有者特权。更多的信息请参见[HDFS 快照指南](http://hadoop.apache.org/docs/r3.3.0/hadoop-project-dist/hadoop-hdfs/HdfsSnapshots.html)

**示例：**
```
hdfs dfs -renameSnapshot /user/hadoop/jerome s1 s2
```

## 14 - deleteSnapshot
**使用方法：**
```
hdfs dfs -deleteSnapshot <path> <snapshotName>
```
从快照目录中删除快照。此操作需要 snaphottable 目录的所有者特权。更多的信息请参见[HDFS 快照指南](http://hadoop.apache.org/docs/r3.3.0/hadoop-project-dist/hadoop-hdfs/HdfsSnapshots.html)

**示例：**
```
hdfs dfs -deleteSnapshot /user/hadoop/jerome s2
```

## 15 - df
**使用方法：**
```
hadoop fs -df [-h] URI [URI ...]
```
显示可用空间。

**参数：**
- -h : 格式化显示大小（例如 64.0M 表示 67108864）。

**示例：**
```
hadoop dfs -df /user/hadoop/dir1
```

## 16 - du
**使用方法：**
```
hadoop fs -du [-s] [-h] [-v] [-x] URI [URI ...]
```
显示目录中所有文件的大小，或者当只指定一个文件时，显示此文件的大小。

**参数：**
- -s : 显示文件长度的汇总摘要，而不是单个文件的摘要。
- -h : 格式化显示大小（例如 64.0M 表示 67108864）。
- -v : 将列名称显示为标题行。
- -x ；将从结果计算中排除快照。

du 以下列格式返回三列：
```
size disk_space_consumed_with_all_replicas full_path_name
```
**示例：**
```
hadoop fs -du /user/hadoop/dir1 /user/hadoop/file1 hdfs://nn.example.com/user/hadoop/dir1
```
**返回值：**
成功返回0，失败返回-1。

## 17 - dus
**使用方法：**
```
hadoop fs -dus <args>
```
显示文件的大小。

**注意：** 不推荐使用此命令。 而是使用 `hadoop fs -du -s`。

## 18 - expunge
**使用方法：**
```
hadoop fs -expunge [-immediate] [-fs <path>]
```
清空回收站。请参考[HDFS 设计](http://hadoop.apache.org/docs/r3.3.0/hadoop-project-dist/hadoop-hdfs/HdfsDesign.html#File_Deletes_and_Undeletes)文档以获取更多关于回收站特性的信息。

**参数：**
- -immediate : 如果添加了该参数，则将立即删除回收站中当前用户的所有文件，而忽略 `fs.trash.interval` 设置。
- -fs : 如果添加了该参数，则将删除提供的文件系统，而不是默认文件系统并创建检查点。

**示例：**
```
hadoop fs -expunge --immediate -fs s3a://landsat-pds/
```

## 19 - find
**使用方法：**
```
hadoop fs -find <path> ... <expression> ...
```
查找满足表达式的所有文件。如果未指定路径，则默认为当前工作目录。如果未指定表达式，则默认为 `-print`。

**参数：**
- -name pattern : 所要查找文件的文件名。
- -iname pattern : 所要查找的文件名，不区分大小写。
- -print : 打印。
- -print0 : 打印在一行。

**示例：**
```
hadoop fs -find / -name test -print
```
**返回值：**

成功返回0，失败返回-1。

## 20 - get
**使用方法：**
```
hadoop fs -get [-ignorecrc] [-crc] [-p] [-f] <src> <localdst>
```
复制文件到本地。

**参数：**
- -p : 保留访问和修改时间以及权限。
- -f : 如果目标文件已经存在，则覆盖。
- -ignorecrc : 对下载的文件跳过CRC检查。
- -crc : 为下载的文件写入CRC校验和。

**示例：**
```
hadoop fs -get /user/hadoop/file localfile
hadoop fs -get hdfs://nn.example.com/user/hadoop/file localfile
```
**返回值：**

成功返回0，失败返回-1。

## 21 - getfacl
**使用方法：**
```
hadoop fs -getfacl [-R] <path>
```
查看文件和目录的访问控制列表（ACL）权限。

**参数：**
- -R : 递归列出所有文件和目录的 ACL 权限。
- path : 列出的文件或目录。

**示例：**
```
hadoop fs -getfacl /file
hadoop fs -getfacl -R /dir
```
**返回值：**

成功返回0，失败返回非零。

## 22 - setfacl
**使用方法：**
```
hadoop fs -setfacl [-R] [-b |-k -m |-x <acl_spec> <path>] |[--set <acl_spec> <path>]
```
设置文件和目录的访问控制列表（ACL）权限。

**参数：**
- -b : 移除所有除了基本的 ACL 条目。用户、组和其它的条目被保留为与权限位的兼容性。
- -k : 删除默认的 ACL。
- -R : 递归应用于所有文件和目录的操作。
- -m : 修改 ACL。新的项目添加到 ACL，并保留现有的条目。
- -x : 删除指定的 ACL 条目。保留其它 ACL 条目。
- --set : 完全替换 ACL，丢弃所有现有的条目。acl_spec 必须包括用户、组、和其它有权限位的兼容性。
- acl_spec : 逗号分隔的 ACL 条目列表。
- path : 修改的文件或目录。

**示例：**
```
hadoop fs -setfacl -m user:hadoop:rw- /file
hadoop fs -setfacl -x user:hadoop /file
hadoop fs -setfacl -b /file
hadoop fs -setfacl -k /dir
hadoop fs -setfacl --set user::rw-,user:hadoop:rw-,group::r--,other::r-- /file
hadoop fs -setfacl -R -m user:hadoop:r-x /dir
hadoop fs -setfacl -m default:user:hadoop:r-x /dir
```
**返回值：**

成功返回0，失败返回非零。

## 23 - getfattr
**使用方法：**
```
hadoop fs -getfattr [-R] -n name | -d [-e en] <path>
```
显示文件或目录的扩展属性名称和值（如果存在）。

**参数：**
- -R : 递归列出所有文件和目录的属性。
- -n name : 转储命名的扩展属性值。
- -d : 转储与路径名关联的所有扩展属性值。
- -e encoding : 检索后的值进行编码。有效的编码是 ` “text”, “hex”, and “base64”`，编码作为文本字符串是用双引号括起来的 `(")`，编码作为十六进制和六十四进制，前缀分别为 0x 和 0s。
- path : 文件或目录。

**示例：**
```
hadoop fs -getfattr -d /file
hadoop fs -getfattr -R -n user.myAttr /dir
```
**返回值：**

成功返回0，失败返回非零。

## 24 - setfattr
**使用方法：**
```
hadoop fs -setfattr -n name [-v value] | -x name <path>
```
设置文件或目录的扩展属性名称和值。

**参数：**
- -n name : 扩展属性名称。
- -v value : 扩展属性值。有三种不同的编码方法。如果参数用双引号引起来，则该值为引号内的字符串。如果参数以 0x 或 0X 为前缀，则将其视为十六进制数。如果参数以 0s 或 0S 开头，则将其作为六十四进制编码。
- -x name : 除去扩展属性。
- path : 文件或目录。

**示例：**
```
hadoop fs -setfattr -n user.myAttr -v myValue /file
hadoop fs -setfattr -n user.noValue /file
hadoop fs -setfattr -x user.myAttr /file
```
**返回值：**

成功返回0，失败返回非零。

## 25 - getmerge
**使用方法：**
```
hadoop fs -getmerge [-nl] <src> <localdst>
```
接受一个源目录和一个目标文件作为输入，并将源目录中所有的文件连接成本地目标文件。

**参数：**
- -nl : 是可选的，用于指定在每个文件结尾添加一个换行符。
- -skip-empty-file : 可以用于在文件为空的情况下避免不需要的换行符。

**示例：**
```
hadoop fs -getmerge -nl /src /opt/output.txt
hadoop fs -getmerge -nl /src/file1.txt /src/file2.txt /output.txt
```
**返回值：**

成功返回0，失败返回非零。

## 26 - head
**使用方法：**
```
hadoop fs -head URI
```
将文件头部 1K 字节的内容输出到 stdout。

**示例：**
```
hadoop fs -head pathname
```
**返回值：**

成功返回0，失败返回非零。

## 27 - help
**使用方法：**
```
hadoop fs -help
```
返回用法输出。

## 28 - ls
**使用方法：**
```
hadoop fs -ls [-C] [-d] [-h] [-q] [-R] [-t] [-S] [-r] [-u] [-e] <args>
```
如果是文件，则按照如下格式返回文件信息：
```
permissions number_of_replicas userid groupid filesize modification_date modification_time filename
   权限          副本数        用户ID   组ID   文件大小     修改日期          修改时间         文件名
```
如果是目录，则返回它直接子文件的一个列表，就像在Unix中一样。目录返回列表的信息如下：
```
permissions userid groupid modification_date modification_time dirname
   权限     用户ID   组ID       修改日期          修改时间         文件名
```
默认情况下，目录中的文件按文件名排序。

**参数：**
- -C : 仅显示文件和目录的路径。
- -d : 目录被列为纯文件。
- -h : 格式化显示大小（例如 64.0M 表示 67108864）。
- -q : 打印文件名。
- -R : 递归列出遇到的子目录。
- -t : 按修改时间对输出进行排序（最新的优先）。
- -S : 按文件大小排序输出。
- -r : 反转排序顺序。
- -u : 使用访问时间而不是修改时间来进行显示和排序。
- -e : 仅显示文件和目录的纠删码策略。

**示例：**
```
hadoop fs -ls /user/hadoop/file1
hadoop fs -ls -e /ecdir
```
**返回值：**

成功返回0，失败返回-1。

## 29 - lsr
**使用方法：**
```
hadoop fs -lsr <args>
```
ls 命令的递归版本。类似于 Unix 中的 `ls -R`。

**注意：** 不推荐使用此命令。 而是使用 `hadoop fs -ls -R`。

## 30 - mkdir
**使用方法：**
```
hadoop fs -mkdir [-p] <paths>
```
将路径 uri 作为参数并创建目录。

**参数：**
- -p : 其行为类似于 Unix 的 `mkdir -p`，它会创建路径中的各级父目录。

**示例：**
```
hadoop fs -mkdir /user/hadoop/dir1 /user/hadoop/dir2
hadoop fs -mkdir hdfs://nn1.example.com/user/hadoop/dir hdfs://nn2.example.com/user/hadoop/dir
```
**返回值：**

成功返回0，失败返回-1。

## 31 - moveFromLocal
**使用方法：**
```
hadoop fs -moveFromLocal <localsrc> <dst>
```
与put命令类似，不同之处在于将源文件复制后删除。

**示例：**
```
hadoop fs -copyFromLocal file1 /user/jerome/
```

## 32 - moveToLocal
**使用方法：**
```
hadoop fs -moveToLocal [-crc] <src> <dst>
```
输出一个 `Not implemented yet` 信息。

## 33 - mv
**使用方法：**
```
hadoop fs -mv URI [URI ...] <dest>
```
将文件从源路径移动到目标路径。这个命令允许有多个源路径，此时目标路径必须是一个目录。不允许在不同的文件系统间移动文件。

**示例：**
```
hadoop fs -mv /user/hadoop/file1 /user/hadoop/file2
hadoop fs -mv hdfs://nn.example.com/file1 hdfs://nn.example.com/file2 hdfs://nn.example.com/file3 hdfs://nn.example.com/dir1
```
**返回值：**

成功返回0，失败返回-1。

## 34 - put
**使用方法：**
```
hadoop fs -put [-f] [-p] [-l] [-d] [ - | <localsrc1> .. ]. <dst>
```
从本地文件系统中复制单个或多个源路径到目标文件系统。也支持从标准输入中读取输入写入目标文件系统。

**参数：**
- -p : 保留访问和修改时间以及权限。
- -f : 如果目标文件已经存在，则将其覆盖。
- -l : 允许 DataNode 将文件延迟保存到磁盘，强制复制因子为 1。此参数将导致持久性降低。
- -d : 跳过后缀为 `._COPYING_.` 临时文件的创建。

**示例：**
```bash
hadoop fs -put localfile /user/hadoop/hadoopfile
hadoop fs -put -f localfile1 localfile2 /user/hadoop/hadoopdir
hadoop fs -put -d localfile hdfs://nn.example.com/hadoop/hadoopfile
#从 stdin 中读取输入
hadoop fs -put - hdfs://nn.example.com/hadoop/hadoopfile
```
**返回值：**

成功返回0，失败返回-1。

## 35 - rm
**使用方法：**
```
hadoop fs -rm [-f] [-r |-R] [-skipTrash] [-safely] URI [URI ...]
```
删除指定的文件。只删除非空目录和文件。请参考 rmr 命令了解递归删除。

如果启用了垃圾回收，则文件系统会将已删除的文件移动到垃圾回收目录。可以通过为参数 `fs.trash.interval`（在 core-site.xml 中）设置。请参考有关[删除垃圾回收站中文件的信息](http://hadoop.apache.org/docs/r3.3.0/hadoop-project-dist/hadoop-common/FileSystemShell.html#expunge)。

**参数：**
- -f : 如果文件不存在，则不显示诊断消息或修改退出状态以反映错误。
- -R : 以递归方式删除目录及其下的任何内容。
- -r : 等同于 `-R`。
- -skipTrash : 将绕过垃圾回收站（如果启用），并立即删除指定的文件。
- -safely : 在删除目录的文件总数大于 `hadoop.shell.delete.limit.num.files`（在 core-site.xml 中，默认值为 100）之前，将需要安全确认。它可以与 `-skipTrash` 一起使用，以防止意外删除大目录。当递归遍历大目录以计算确认之前要删除的文件数时，预计会出现延迟。

**示例：**
```
hadoop fs -rm hdfs://nn.example.com/file /user/hadoop/emptydir
```
**返回值：**

成功返回0，失败返回-1。

## 36 - rmdir
**使用方法：**
```
hadoop fs -rmdir [--ignore-fail-on-non-empty] URI [URI ...]
```
删除空目录。

**参数：**
- --ignore-fail-on-non-empty : 忽略因目录非空删除失败的信息。

**示例：**
```
hadoop fs -rmdir /user/hadoop/emptydir
```

## 37 - rmr
**使用方法：**
```
hadoop fs -rmr [-skipTrash] URI [URI ...]
```
删除的递归目录。

**注意：** 不推荐使用此命令。而是使用 `hadoop fs -rm -r`。

## 38 - setrep
**使用方法：**
```
hadoop fs -setrep [-R] [-w] <numReplicas> <path>
```
改变一个文件的副本系数。如果是目录，则该命令以递归方式更改以该目录为根目录树下所有文件的副本系数。执行此命令时，将忽略 EC 文件。

**参数：**
- -w : 请求命令等待复制完成。这可能会花费很长时间。
- -R : 选项用于递归改变目录下所有文件的副本系数。

**示例：**
```
hadoop fs -setrep -w 3 /user/hadoop/dir1
```
**返回值：**

成功返回0，失败返回-1。

## 39 - stat
**使用方法：**
```
hadoop fs -stat [format] <path> ...
```
返回指定路径上文件/目录的统计信息。格式接受八进制（％a）和符号（％A）的许可，文件大小以字节（％b），类型（％F），所有者的组名（％g），名称（％n），块大小（％o） ），复制（％r），所有者（％u）的用户名，访问日期（％x，％X）和修改日期（％y，％Y）。 ％x和％y显示UTC日期为 `yyyy-MM-dd HH：mm：ss`，％X和％Y显示自1970年1月1日以来的毫秒数。如果未指定格式，则默认使用（％y）。

**示例：**
```
hadoop fs -stat "type:%F perm:%a %u:%g size:%b mtime:%y atime:%x name:%n" /file
```
**返回值：**

成功返回0，失败返回-1。

## 40 - tail
**使用方法：**
```
hadoop fs -tail [-f] URI
```
将文件尾部 1K 字节的内容输出到 stdout。

**参数：**
- -f : 与 Unix 中一样，当文件内容更新时，输出将会改变，具有实时性。

**示例：**
```
hadoop fs -tail pathname
```
**返回值：**

成功返回0，失败返回-1。

## 41 - test
**使用方法：**
```
hadoop fs -test -[defswrz] URI
```
判断文件信息。

**参数：**
- -d：如果路径是目录，则返回0。
- -e：如果路径存在，则返回0。
- -f：如果路径是文件，则返回0。
- -s：如果路径不为空，则返回0。
- -w：如果路径存在并且授予写许可权，则返回0。
- -r：如果路径存在并且授予读取权限，则返回0。
- -z：如果文件的长度为零，则返回0。

**示例：**
```
hadoop fs -test -e filename
```

## 42 - text
**使用方法：**
```
hadoop fs -text <src>
```
将源文件输出为文本格式。允许的格式是 zip 和 TextRecordInputStream。

**示例：**
```
hadoop fs -text /user/hadoop/jerome.jar
```

## 43 - touch
**使用方法：**
```
hadoop fs -touch [-a] [-m] [-t TIMESTAMP] [-c] URI [URI ...]
```
将指定文件的访问和修改时间更新为当前时间。如果该文件不存在，则会在 URI 处创建一个 0 字节的空文件，并将当前时间作为该 URI 的时间戳。

**参数：**
- -a : 仅更改访问时间。
- -m : 仅更改修改时间。
- -t : 指定时间戳记（格式为 `yyyyMMddHHmmss`）而不是当前时间。
- -c : 如果文件不存在，则不创建文件。

时间戳格式如下：
- yyyy 四位数字的年份（例如：2018）
- MM 两位数字的月份（例如：08 表示八月）
- dd 两位数字的一天（例如：01 表示每月的第一天）
- HH 以 24 小时表示法表示一天中的两位数小时（例如：23 代表 11 pm，11 代表11 am）
- mm 每小时的两位数分钟
- ss 分钟的两位数秒，例如：20180809230000 代表2018年8月9日，11pm

**示例：**
```
hadoop fs -touch pathname
hadoop fs -touch -m -t 20180809230000 pathname
hadoop fs -touch -t 20180809230000 pathname
hadoop fs -touch -a pathname
```
**返回值：**

成功返回0，失败返回-1。

## 44 - touchz
**使用方法：**
```
hadoop fs -touchz URI [URI ...]
```
创建一个 0 字节的空文件。如果文件存在非 0 字节的空文件，则返回错误

**示例：**
```
hadoop fs -touchz pathname
```
**返回值：**

成功返回0，失败返回-1。

## 45 - truncate
**使用方法：**
```
hadoop fs -truncate [-w] <length> <paths>
```
将与指定文件模式匹配的所有文件截断为指定长度。

**参数：**
- -w : 要求命令在必要时等待块恢复完成。这可能会花费很长时间。如果没有该参数，则在恢复过程中，文件可能会保持关闭状态一段时间。在此期间，无法重新打开文件进行追加。

**示例：**
```
hadoop fs -truncate 55 /user/hadoop/file1 /user/hadoop/file2
hadoop fs -truncate -w 127 hdfs://nn1.example.com/user/hadoop/file1
```

## 46 - usage
**使用方法：**
```
hadoop fs -usage command
```
返回单个命令的帮助信息。

**示例：**
```
hadoop fs -usage ls
```

## 47 - distcp
**使用方法：**
```
hadoop distcp URL1 URL2
```
DistCp（分布式拷贝）是用于大规模集群内部和集群之间拷贝的工具。它使用 Map/Reduce 实现文件分发，错误处理和恢复，以及报告生成。它把文件和目录的列表作为 map 任务的输入，每个任务会完成源列表中部分文件的拷贝。由于使用了 Map/Reduce 方法，这个工具在语义和执行上都会有特殊的地方。

**参数**
- -f : 从文件里获得多个源

**示例：**
```
hadoop distcp hdfs://nn1:8020/foo/bar hdfs://nn2:8020/bar/foo
hadoop distcp hdfs://nn1:8020/foo/a hdfs://nn1:8020/foo/b hdfs://nn2:8020/bar/foo
hadoop distcp -f hdfs://nn1:8020/srclist hdfs://nn2:8020/bar/foo
```

## 48 - dfsadmin
**使用方法：**
```bash
#把每个目录配额设为 N 个字节。该命令会在每个目录上尝试，如果 N 不是一个正的长整型数，目录不存在或是文件名，或者目录超过配额，则会错误报告。
hdfs dfsadmin -setquota <N> <directory>...<directory>

#删除每个目录的任何空间配额。该命令会在每个目录上尝试，如果目录不存在或者是文件，则会错误报告。如果目录原来没有设置配额不会报错。
hdfs dfsadmin -clrQuota <directory>...<directory>

#将每个目录的空间配额设置为 N 个字节。这是对目录树下所有文件总大小的硬限制。空间配额还考虑了复制，即复制 1 的 3 GB 数据消耗 3GB 的配额。为了方便起见，也可以使用二进制前缀指定 N（例如：50g 表示 50GB，2t 表示 2TB 等）。该命令为每个目录提供服务，如果 N 既不是零也不是正整数，则报告错误，则该目录不存在或它是一个文件，否则目录将立即超过新的配额。
hdfs dfsadmin -setSpaceQuota <N> <directory>...<directory>

#删除每个目录的任何空间配额。该命令会在每个目录上尝试，如果目录不存在或为文件，则会报告错误。如果目录没有配额，这不是错误。
hdfs dfsadmin -clrSpaceQuota <directory>...<directory>

#将存储类型配额设置为为每个目录指定的 N 个字节的存储类型。这是目录树下所有文件的总存储类型使用情况的硬限制。存储类型配额使用情况反映了基于存储策略的预期使用情况（例如：复制 3 和 ALL_SSD 存储策略的 1GB 数据将消耗 3GB 的 SSD 配额）。为了方便起见，也可以使用二进制前缀指定 N（例如：50g 表示 50GB，2t 表示 2TB 等）。该命令为每个目录提供服务，如果N既不是零也不是正整数，则报告错误，则该目录不存在或它是一个文件，否则目录将立即超过新的配额。指定 -storageType 选项时，将设置特定于存储类型的配额。可用的存储类型为 DISK，SSD，ARCHIVE，PROVIDED。
hdfs dfsadmin -setSpaceQuota <N> -storageType <storagetype> <directory>...<directory>

#删除为每个目录指定的存储类型配额。该命令会在每个目录上尝试，如果目录不存在或为文件，则会报告错误。如果目录没有指定存储类型的存储配额，这不是错误。指定 -storageType 选项时，将清除特定于存储类型的配额。可用的存储类型为 DISK，SSD，ARCHIVE，PROVIDED。
hdfs dfsadmin -clrSpaceQuota -storageType <storagetype> <directory>...<directory>
```
设置目录配额。配额由仅对管理员可用的一组命令进行管理。

**示例：**

限制 test.db 数据库的 HDFS 使用空间为 10T
```
hdfs dfsadmin -setSpaceQuota 10995116277760 /user/hive/warehouse/test.db
```

> 参考官方文档：http://hadoop.apache.org/docs/r3.3.0/hadoop-project-dist/hadoop-common/FileSystemShell.html#deleteSnapshot
