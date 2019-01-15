# Apache ZooKeeper

Use an official Apache ZooKeeper image.

* [zookeeper - Docker Hub](https://hub.docker.com/_/zookeeper/)
* [31z4/zookeeper-docker](https://github.com/31z4/zookeeper-docker)

```shell
$ docker pull zookeeper:3.4.13
```

```shell
$ docker volume create zk-data
```
```shell
$ docker volume create zk-datalog
```
```shell
$ docker volume create zk-logs
```

```shell
$ docker run --name zookeeper --rm -dit -p 127.0.0.1:2181:2181 -v zk-data:/data -v zk-datalog:/datalog -v zk-logs:/logs zookeeper:3.4.13
```
```shell
$ docker run -it --rm --link zookeeper:zkclient zookeeper:3.4.13 zkCli.sh -server zookeeper
```
```shell
$ docker attach zookeeper
^C
```

