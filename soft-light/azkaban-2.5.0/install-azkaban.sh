#!/bin/bash

wget -P tars https://s3.amazonaws.com/azkaban2/azkaban2/2.5.0/azkaban-web-server-2.5.0.tar.gz
wget -P tars https://s3.amazonaws.com/azkaban2/azkaban2/2.5.0/azkaban-executor-server-2.5.0.tar.gz
wget -P tars https://s3.amazonaws.com/azkaban2/azkaban2/2.5.0/azkaban-sql-script-2.5.0.tar.gz
wget -P tars https://s3.amazonaws.com/azkaban2/azkaban-plugins/2.5.0/azkaban-hdfs-viewer-2.5.0.tar.gz
wget -P tars https://s3.amazonaws.com/azkaban2/azkaban-plugins/2.5.0/azkaban-jobtype-2.5.0.tar.gz
wget -P tars https://s3.amazonaws.com/azkaban2/azkaban-plugins/2.5.0/azkaban-jobsummary-2.5.0.tar.gz
wget -P tars https://s3.amazonaws.com/azkaban2/azkaban-plugins/2.5.0/azkaban-reportal-2.5.0.tar.gz
# git clone https://github.com/azkaban/azkaban.git
# cd azkaban
# git checkout 059b0d1
## 最新的版本将 log 路径默认为 /, 所以使用059b0d1来代替
