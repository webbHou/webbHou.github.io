---
title: Docker容器入门和实践
tags:
  - javascript
  - docker
categories: 计算机知识
date: 2020-11-25 15:20:05
---

#### 为什么要使用docker

在软件开发中，我们每一个软件应用都需要它自身的运行环境，所以往往我们在本机跑的应用并不代表在别的机器可以跑起来，在本地部署的环境在其他还得重新部署一遍，有时候粗心大意还会缺失，浪费时间精力。所以技术人想为什么我们不把所有这个应用相关的打包到一起，安装的时候把原始环境复制一份到当前机器。

1.虚拟机vm：就是一种自带环境的解决方案，可以在一个操作系统中再运行一个操作系统。跟你的真实系统基本一样。对于底层来说，虚拟机就是一个文件，不需要了就可以删掉，毫无影响。所以用来还原应用的运行环境特别方便。

缺点：

- 启动慢：因为跟操作系统一样  需要时间启动
- 占用内存多：需要自己占用一部分内存(即使可能用不到)，不能共享
- 冗余步骤多：因为是操作系统级别的，一些系统的操作不能跳过，比如用户登录

2.linux容器：进程级的应用，对进程进行隔离，把本地资源做一个映射到该容器去使用，所以本地资源都是虚拟的，从而实现跟本地的隔离。

优点：

- 启动快：进程级别，相当于启动一个进程
- 资源占用小：只占用自己用到的部分 不同容器间还可以共享
- 体积小：只包含自己用到的组件和依赖

#### docker

linux容器的一种，对linux容器做了一次封装，提供简单易用的容器使用接口。Docker把应用程序相关的都打包到一起，每次运行都会生成一个新的虚拟容器，程序就可以在这个虚拟容器里运行，而不需要担心环境问题。

用途：

- 一次性的安装环境：服务端应用部署、第三方测试、搭建构建环境
- 组建微服务架构：比如后端的高并发，可以在多台服务器进行部署进行负载均衡，大量的docker容器可以使用K8s进行管理
- 云服务：因为方便管理，启动又快，非常适合扩容和缩容

##### image

Docker把应用程序相关的都打包到一起的文件就叫做image(镜像)，image就相当于模板，通过image才可以生成容器实例，同一个image可以生成多个运行容器。

```bash
# 列出本机的所有 image 文件。
$ docker image ls

# 删除 image 文件
$ docker image rm [imageName]

# 拉取远程仓库镜像到本地 仓库名/image名称
$ docker image pull library/hello-world
```

##### container

运行image生成的容器实例，容器关闭或停止运行并不会删除容器 依旧占用内存

```bash
# 根据hello-world镜像生成并启动一个docker容器 每次都会重新生成
docker container run hello-world

# 杀死一个容器进程
$ docker container kill [containID]

# 停止一个容器进程 相对于kill更柔和 不会立马停止
$ bash container stop [containerID]

# 启动一个已有的容器  
$ docker container start [containerID]

# 删除一个容器
$ docker container rm [containerID]

# 列出本机正在运行的容器
$ docker container ls

# 列出本机所有容器，包括终止运行的容器
$ docker container ls --all

# 生成一个容器映射端口并重命名
$ docker run -d -p 80:80 --name 容器名  镜像名
```

#### 制作docker镜像

我们可以把自己本地的应用打包成docker容器并发布到远程仓库，就可以在其他机器进行实例化容器

- .dockerignore image打包时忽略文件夹

```txt
.git
node_modules
npm-debug.log
```

- Dockerfile：打包image配置文件

```bash
FROM node:8.4：该 image 文件继承官方的 node image，冒号表示标签，这里标签是8.4，即8.4版本的 node。
COPY . /app：将当前目录下的所有文件（除了.dockerignore排除的路径），都拷贝进入 image 文件的/app目录。
WORKDIR /app：指定接下来的工作路径为/app。
RUN npm install：在/app目录下，运行npm install命令安装依赖。注意，安装后所有的依赖，都将打包进入 image 文件。RUN命令都在打包完成前执行
EXPOSE 3000：将容器 3000 端口暴露出来， 允许外部连接这个端口。
CMD node demos/01.js 容器启动后自执行命令

# 生成koa-demo 镜像 -t指定image名称 :指定tag标签 可以做版本管理 .表示Dockerfile配置文件的路径
$ docker image build -t koa-demo .
# 或者
$ docker image build -t koa-demo:0.0.1 .
```

- 发布image

```bash
# 生成自己仓库名的image
$ docker image build -t [username]/[repository]:[tag] .

# 发布
$ docker image push [username]/[repository]:[tag]
```

#### 生成容器

```bash
$ docker container run -p 8000:3000 -it koa-demo /bin/bash
# 或者
$ docker container run -p 8000:3000 -it koa-demo:0.0.1 /bin/bash

# 在容器运行结束后删除
$ docker container run --rm -p 8000:3000 -it koa-demo /bin/bash
```

- -p参数：容器的 3000 端口映射到本机的 8000 端口。
- -it参数：容器的 Shell 映射到当前的 Shell，然后你在本机窗口输入的命令，就会传入容器。
- koa-demo:0.0.1：image 文件的名字（如果有标签，还需要提供标签，默认是 latest 标签）。
- /bin/bash：容器启动以后，内部第一个执行的命令。这里是启动 Bash，保证用户可以使用 Shell。
