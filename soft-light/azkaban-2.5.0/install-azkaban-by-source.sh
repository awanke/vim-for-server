#!/bin/bash

azkaban 安装指南
========

参考
-----

* [official documentation](http://azkaban.github.io/azkaban/docs/2.5)

下载
-----

```bash
$ git clone https://github.com/azkaban/azkaban.git
$ cd azkaban
$ git checkout 059b0d1
## 最新的版本将 log 路径默认为 /, 所以使用059b0d1来代替
```

### 编译

```bash
# 确保 python 是2.x版本, 3.x版本的通不过python的测试用例
# 确保安装了 git
# 确保使用 git clone, 而非直接下载压缩包, 会用到 .git 目录下的信息
$ cd azkaban
$ ./gradlew distTar
```

安装包目录为: build/distributions, 内含5个压缩包:

* azkaban-exec-server-2.6.4.tar.gz
* azkaban-migration-2.6.4.tar.gz
* azkaban-solo-server-2.6.4.tar.gz
* azkaban-sql-2.6.4.tar.gz
* azkaban-web-server-2.6.4.tar.gz

我们只需要其中的3个:

* azkaban-exec-server-2.6.4.tar.gz
* azkaban-web-server-2.6.4.tar.gz
* azkaban-sql-2.6.4.tar.gz

分别对应 azkaban 的执行器, azkaban 前端服务, 和mysql初始化脚本.

### 解压

解压这三个压缩包, 并放到 /hadoop/azkaban 目录下:

```bash
$ mkdir /hadoop/azkaban
$ tar -xvf azkaban-exec-server-2.6.4.tar.gz
$ mv azkaban-exec-server-2.6.4 /hadoop/azkaban/azkaban-exec-server

$ tar -xvf azkaban-web-server-2.6.4
$ mv azkaban-web-server-2.6.4 /hadoop/azkaban/azkaban-web-server

$ tar -xvf azkaban-sql-2.6.4
```

数据库设置
-------

当前只支持 mysql 数据库

```bash
$ mysql -uroot -p

mysql> CREATE DATABASE azkaban;
mysql> CREATE USER 'azkaban'@'%' IDENTIFIED BY 'azkaban';
mysql> GRANT SELECT,INSERT,UPDATE,DELETE ON azkaban.* to 'azkaban'@'%' WITH GRANT OPTION;

# 执行 azkaban 提供的 sql 脚本来创建需要的表
$ cd azkaban-sql-2.6.4
$ mysql -uroot -p -Dazkaban < create-all-sql-2.6.4.sql
```

扩大 mysql 的 Packet Size 项的大小: 

```bash
$ vim /etc/mysql/my.cnf
# 将 max_allowed_packet 项设置的大些, 比如 1024M
[mysqld]
max_allowed_packet=1024M
```

重启 mysql: 

```bash
sudo service mysql restart
```

配置 keystore
------------

azkaban 的 webservice 需要用到 https , 要配置 keystore.

```bash
$ cd azkaban-web-service
$ keytool -keystore keystore -alias jetty -genkey -keyalg RSA


Enter keystore password:    
   Re-enter new password:   
   What is your first and last name?  
     [Unknown]:  azkaban  
   What is the name of your organizational unit?  
     [Unknown]:  azkaban  
   What is the name of your organization?  
     [Unknown]:  cci
   What is the name of your City or Locality?  
     [Unknown]:  hangzhou  
   What is the name of your State or Province?  
     [Unknown]:  zhejiang  
   What is the two-letter country code for this unit?  
     [Unknown]:  CN  
   Is CN=azkaban.test.com, OU=azkaban, O=test, L=beijing, ST=beijing, C=CN correct?  
     [no]:  yes  
 
   Enter key password for <azkaban>  
           (RETURN if same as keystore password):
```

配置文件
--------

### azkaban web server

配置文件所在目录为 conf 目录, 配置 azkaban.properties 如下, 特别注意修改 mysql, jetty
这些项目为对应的值:

```bash
# Azkaban Personalization Settings
azkaban.name=Test
azkaban.label=My Local Azkaban
azkaban.color=#FF3601
azkaban.default.servlet.path=/index
web.resource.dir=web/
default.timezone.id=Asia/Shanghai

# Azkaban UserManager class
user.manager.class=azkaban.user.XmlUserManager
user.manager.xml.file=conf/azkaban-users.xml

# Loader for projects
executor.global.properties=conf/global.properties
azkaban.project.dir=projects

database.type=mysql
mysql.port=3306
mysql.host=localhost
mysql.database=azkaban
mysql.user=azkaban
mysql.password=azkaban
mysql.numconnections=100

# Velocity dev mode
velocity.dev.mode=false

# Azkaban Jetty server properties.
jetty.maxThreads=25
jetty.ssl.port=8443
jetty.port=8081
jetty.keystore=keystore
jetty.password=azkaban
jetty.keypassword=azkaban
jetty.truststore=keystore
jetty.trustpassword=azkaban

# Azkaban Executor settings
executor.port=12321

# mail settings
mail.sender=
mail.host=
job.failure.email=
job.success.email=

lockdown.create.projects=false

cache.directory=cache

# JMX stats
jetty.connector.stats=true
executor.connector.stats=true
```

### azkaban exec server

配置文件所在文件夹为 conf, 编辑 azkaban.properties 如下, 注意修改 mysql, hadoop.home 为对应值:

```bash
# Azkaban
default.timezone.id=Asia/Shanghai

# Azkaban JobTypes Plugins
azkaban.jobtype.plugin.dir=plugins/jobtypes

# Loader for projects
executor.global.properties=conf/global.properties
azkaban.project.dir=projects

database.type=mysql
mysql.port=3306
mysql.host=localhost
mysql.database=azkaban
mysql.user=azkaban
mysql.password=azkaban
mysql.numconnections=100

# Azkaban Executor settings
executor.maxThreads=50
executor.port=12321
executor.flow.threads=30

# JMX stats
jetty.connector.stats=true
executor.connector.stats=true

# uncomment to enable inmemory stats for azkaban
#executor.metric.reports=true
#executor.metric.milisecinterval.default=60000


# job type plugins
hadoop.home=/hadoop/hadoop
jobtype.global.classpath=${hadoop.home}/my-lib,${hadoop.home}/etc/hadoop
```

### JDBC

下载 [mysql 的 JDBC](http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.36.tar.gz), 分别放到 web 和 exec 的 extlib 目录下.


启动/关闭
--------

### 启动 azkaban

    $ bin/azkaban-web-start.sh
    $ bin/azkaban-exec-start.sh

### 关闭 azkaban

    $ bin/azkaban-web-shutdown.sh
    $ bin/azkaban-exec-shutdown.sh

基本操作
------

查看 web 页面, 使用用户名: azkaban, 密码:azkaban 登陆[页面](https://namenode:8443).

新建项目, 并上传一个简单的工作流, 如果能够正常执行, 则安装成功.


```bash
$ vim foo.job

## foo.job
type=command
command=echo "Hello World"

## 将foo.job打包成 zip 文件
$ 7z a test.zip command-example.job

## 将 test.zip 通过 azkaban 的 web 页面上传, 并执行
```
