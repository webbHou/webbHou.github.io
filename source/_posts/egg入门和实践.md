---
title: egg入门和实践
tags:
  - egg
  - nodejs
categories: nodejs
date: 2020-10-24 19:00:13
---

#### egg和koa的区别

- api上：更好的封装，使开发人员只注重于业务而不需要原理，更简单方便的去写业务
- 脚手架：
  * 文件分割：根据controller、service、config去存放和管理，便于后期维护
  * ts支持：会自动生成相关文件的d.ts类型文件，存放于typings文件夹下，与业务目录形成映射
  * test、eslint、log支持
- 插件系统：强大的插件系统让你可以直接使用第三方插件，配置简单
- configs：根据环境进行区分，可以配置不同环境的数据和参数