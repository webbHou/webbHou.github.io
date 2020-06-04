---
title: 前端应该了解的http知识
tags:
  - javascript
categories: js常见问题
date: 2020-04-10 17:58:41
---

##### 协议：数据传输格式的规范。
##### http协议：超文本传输协议，无状态协议，没有记忆功能，属于应用层。

#### Tcp协议：
* http的底层协议，属于传输层，跟http一样是无连接协议，将两端连接起来，实际上只是两端维护了一个状态。
* 全双工协议，需要确保双方都能接受和发送数据，所以需要三次握手和四次挥手。
* 连接中任意一方掉线都会重新开始连接，一般会重连5次。这也是它是无状态的原因。


#### 简单请求和非简单请求

**非简单请求会在真正请求前发送一个预检请求，options，以获知服务器是否允许该实际请求。**但会浪费时间和性能，所以需要减少和避免。

###### 以下为非简单请求：
- 请求方式不属于GET、POST、HEAD
- 不得人为设置其他首部字段
- Content-type值不属于：application/x-www-form-urlencoded、multipart/form-data、text/plain

#### http的general header：
- Request URL：请求资源地址
- Request Method: GET
- Status Code: 状态码

#### http请求格式：

- 请求头：
  * Accept-Encoding: 可以兼容的压缩格式
  * host：请求主机
  * origin：请求源，可以用于服务端设置请求白名单
  * Referer：请求页的地址
  * Accept-language：请求目标语言
  * user-agent：浏览器的版本和客户端系统
  * content-type：post请求独有的请求头

- 请求体：
  * post：独有的请求体
  * get：拼接在地址栏中
        

#### http响应格式：

- 响应头：
    * Access-Control-Allow-Methods: 允许的请求方式
    * Access-Control-Allow-Origin: 允许的请求源
    * Content-Type: 响应体文档类型和编码格式
    * Date: 时间
    * ETag: 文件唯一标识
    * cache-control: 最大缓存过期时间（秒）
    * expires：缓存过期时间（date格式）
    * Last-Modified：最后一次文件修改时间
    * content-encoding： 压缩格式
    
- 响应体


