---
title: egg入门和实践
tags:
    - egg
    - nodejs
categories: nodejs
date: 2020-10-24 19:00:13
---

### egg、koa、express、nest 直接关系

express 是最早的 nodejs 框架，使用回调函数处理异步。
koa 是 express 原班人马打造的，丢掉回调方式，使用 async 函数处理异步（koa1 使用 generator 函数），不绑定任何框架，插件化，随意定制，轻量级。
nest 是使用 typescript 封装的 koa，使用依赖注入，装饰器等特性，使代码更易维护，更易扩展，更易测试。
egg 是使用 koa 封装的，使用插件系统，使开发人员只注重于业务而不需要原理，更简单方便的去写业务。

#### egg 和 koa 的区别

-   api 上：更好的封装，使开发人员只注重于业务而不需要原理，更简单方便的去写业务
-   脚手架：
    -   文件分割：根据 controller、service、config 去存放和管理，便于后期维护
    -   ts 支持：会自动生成相关文件的 d.ts 类型文件，存放于 typings 文件夹下，与业务目录形成映射
    -   test、eslint、log 支持
-   插件系统：强大的插件系统让你可以直接使用第三方插件，配置简单
-   configs：根据环境进行区分，可以配置不同环境的数据和参数
