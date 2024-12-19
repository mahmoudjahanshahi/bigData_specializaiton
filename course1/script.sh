#!/bin/bash

# setting up containers
cd hadoop
docker-compose up -d

# copy required files
docker cp ./mapred-site.xml hadoop-namenode-1:/opt/hadoop/etc/hadoop/mapred-site.xml 
docker cp ./words.txt hadoop-namenode-1:/opt/hadoop/words.txt

# get into container environment and copy word.txt
docker exec -it hadoop-namenode-1 /bin/bash
hdfs dfs -mkdir -p /user/hadoop
hdfs dfs -copyFromLocal words.txt

# run wordcount on hadoop
yarn jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar wordcount words.txt out
hdfs dfs -copyToLocal out/part-r-00000 local.txt
# exit

# retrieve results
docker cp hadoop-namenode-1:/opt/hadoop/local.txt ../wordcount_results.txt

# quiz
docker cp ./alice.txt hadoop-namenode-1:/opt/hadoop/alice.txt 
docker exec -it hadoop-namenode-1 /bin/bash
hdfs dfs -copyFromLocal alice.txt
yarn jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar wordcount alice.txt quiz
hdfs dfs -copyToLocal quiz/part-r-00000 result.txt
yarn jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar wordmedian alice.txt quiz2
# exit
docker cp hadoop-namenode-1:/opt/hadoop/result.txt ../quiz_results.txt
