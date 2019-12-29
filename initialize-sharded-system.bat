@echo off

echo Start Shards 0/1/2 - Replica Sets 0/1/2 Members

start mongo-binaries\mongod -f shard-servers\shard0\replica0\configuration\mongod.conf
start mongo-binaries\mongod -f shard-servers\shard0\replica1\configuration\mongod.conf
start mongo-binaries\mongod -f shard-servers\shard0\replica2\configuration\mongod.conf
start mongo-binaries\mongod -f shard-servers\shard1\replica0\configuration\mongod.conf
start mongo-binaries\mongod -f shard-servers\shard1\replica1\configuration\mongod.conf
start mongo-binaries\mongod -f shard-servers\shard1\replica2\configuration\mongod.conf
start mongo-binaries\mongod -f shard-servers\shard2\replica0\configuration\mongod.conf
start mongo-binaries\mongod -f shard-servers\shard2\replica1\configuration\mongod.conf
start mongo-binaries\mongod -f shard-servers\shard2\replica2\configuration\mongod.conf

timeout /T 30 /NOBREAK >NUL

echo Configure Replica Sets

start mongo-binaries\mongo --port 37017 --eval "rs.initiate({_id:'shard0',members:[{_id:0,host:'127.0.0.1:37017'},{_id:1,host:'127.0.0.1:37018'},{_id:2,host:'127.0.0.1:37019'}]});"
start mongo-binaries\mongo --port 47017 --eval "rs.initiate({_id:'shard1',members:[{_id:0,host:'127.0.0.1:47017'},{_id:1,host:'127.0.0.1:47018'},{_id:2,host:'127.0.0.1:47019'}]});"
start mongo-binaries\mongo --port 57017 --eval "rs.initiate({_id:'shard2',members:[{_id:0,host:'127.0.0.1:57017'},{_id:1,host:'127.0.0.1:57018'},{_id:2,host:'127.0.0.1:57019'}]});"

timeout /T 30 /NOBREAK >NUL

echo Start Configuration Replica Set Members

start mongo-binaries\mongod -f shard-configuration-servers\config0\configuration\mongod.conf
start mongo-binaries\mongod -f shard-configuration-servers\config1\configuration\mongod.conf
start mongo-binaries\mongod -f shard-configuration-servers\config2\configuration\mongod.conf

timeout /T 30 /NOBREAK >NUL

echo Configure Configuration Servers Replica Set

start mongo-binaries\mongo --port 57060 --eval "rs.initiate({_id:'configReplSet', configsvr:true, members:[{_id:0,host:'127.0.0.1:57060'},{_id:1,host:'127.0.0.1:57061'},{_id:2,host:'127.0.0.1:57062'}]});"

timeout /T 30 /NOBREAK >NUL

echo Start Shard Server

start mongo-binaries\mongos -f mongo-router-server\configuration\mongos.conf

timeout /T 30 /NOBREAK >NUL

echo Configure Shard Server

start mongo-binaries\mongo --port 27017 --eval "sh.addShard('shard0/127.0.0.1:37017'); sh.addShard('shard1/127.0.0.1:47017'); sh.addShard('shard2/127.0.0.1:57017');"