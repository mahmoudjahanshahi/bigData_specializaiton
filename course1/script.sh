#!/bin/bash

# setting up containers
cd hadoop
docker-compose up -d

# copy required files
docker cp ./mapred-site.xml hadoop-namenode-1:/opt/hadoop/etc/hadoop/mapred-site.xml 
docker cp ./words.txt hadoop-namenode-1:/opt/hadoop/words.txt

# run wordcount on hadoop
docker exec -it hadoop-namenode-1 /bin/bash
hdfs dfs -copyFromLocal words.txt
yarn jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar wordcount words.txt out
hdfs dfs -copyToLocal out/part-r-00000 local.txt
exit

# retrieve results
docker cp hadoop-namenode-1:/opt/hadoop/local.txt ../local.txt
