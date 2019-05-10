---
title: webpack打包原理浅析
tags:
  - javascript
categories: js常见问题
date: 2019-05-8 19:48:20
---


在前端模块化和工程化的演变进程中，涌现出了大量模块化规范和工程化工具，这些规范和工具使我们在编码中更规范，提升了我们代码的复用率，使我们的开发效率和编码得到提高，大大解放了我们的生产力。

- 模块化规范：
  * CMD规范：module.export | require 
  * Sea.js：类似于CMD规范
  * AMD规范：define | require
  * Es6模块化：export | import

- 工程化工具
  * Grunt：构建工具 同步 不够灵活
  * npm | bower：包管理工具
  * Gulp：自动化构建工具 异步 管道式处理 更快
  * webpack：静态资源打包工具


  **在当前前端市场，由于webpack功能的强大和全面，已经在市场上占据了大量的用户，所以本文主要简析webpack**

  #### wbepack的几大核心板块

  - entry：打包的入口文件，对应用的模块依赖关系做了指示，作为应用构建的开始  默认为'./src/index.js' 可自定义一个或多个入口
  - output：打包的出口，即打包后的文件位置及文件名，path：打包后存放的文件夹路径，filename：打包后的文件名
  - loader： 由于webpack只能识别js|json文件，所以需要loader对静态资源文件进行计算处理，根据不同类型文件，使用不同loader并打包成可用的模块，相当于处理器 
  - plugin：plugin相对于loader更加强大，打包优化(压缩，提取公共，预加载等)，资源的管理(html注入打包后module)，环境变量管理(开发和生产环境)
  - mode：设置当前环境模式来做不同处理（development，production，none）


  #### webpack打包原理

  - 从打包入口进入，把所有依赖的模块按依赖顺序放入一个空数组中
  - 把该数组传入一个自执行函数中，该函数被html引入，当页面在浏览器中打开时被执行
  - 执行第一个模块即入口模块，然后根据入口模块所依赖模块的数组索引找到依赖模块引入
  - 所有模块被打包进数组时，接受一个module和require方法，module.export对外暴露自己，require用来按索引引入所需模块
  - 这样按照每个模块的依赖关系来构建起整个应用