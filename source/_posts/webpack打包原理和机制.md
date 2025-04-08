---
title: webpack打包原理和机制
tags:
  - javascript
  - webpack
categories: js常见问题
date: 2019-05-8 19:48:20
---

在前端模块化和工程化的演变进程中，涌现出了大量模块化规范和工程化工具，这些规范和工具使我们在编码中更规范，提升了我们代码的复用率，使我们的开发效率和编码得到提高，大大解放了我们的生产力，不需要我们去手动引入模块。

#### 模块化规范

- CMD 规范：module.export | require 同步
- Sea.js：类似于 CMD 规范
- AMD 规范：define | require 异步模块规范

```javascript
//第一个参数是该模块依赖的其他模块  第二参数是一个函数 参数是依赖模块的默认导出成员 里边定义了这个模块实现的功能和方法
define(["jquery", "./module.js"], ($, module2) => {
  return {
    // return 出的东西就是该模块的导出成员
    start: function () {
      $("body").text("111");
    },
  };
});

//第一个参数是该模块引入的其他模块 第一个参数可以对依赖模块进行使用
require(["./module1.js"], function (module1) {
  module1.start();
});
```

- Es6 模块化：export | import

#### 工程化工具

- Grunt：构建工具 同步 不够灵活
- npm | bower：包管理工具
- Gulp：自动化构建工具 异步 管道式处理 更快
- webpack：静态资源打包工具

  **在当前前端市场，由于 webpack 功能的强大和全面，已经在市场上占据了大量的用户，所以本文主要简析 webpack**

#### wbepack 的几大核心板块

- entry：打包的入口文件，对应用的模块依赖关系做了指示，作为应用构建的开始 默认为'./src/index.js' 可自定义一个或多个入口
- output：打包的出口，即打包后的文件位置及文件名，path：打包后存放的文件夹路径，filename：打包后的文件名
- loader： 由于 webpack 只能识别 js|json 文件，所以需要 loader 对静态资源文件进行计算处理，根据不同类型文件，使用不同 loader 并打包成可用的模块，相当于处理器
- plugin：plugin 相对于 loader 更加强大，打包优化(压缩，提取公共，预加载等)，资源的管理(html 注入打包后 module)，环境变量管理(开发和生产环境)
- mode：设置当前环境模式来做不同处理（development，production，none）

#### webpack 打包原理

- 从打包入口进入，把所有依赖的模块按依赖顺序放入一个空数组中
- 把该数组传入一个自执行函数中，该函数被 html 引入，当页面在浏览器中打开时被执行
- 执行第一个模块即入口模块，然后根据入口模块所依赖模块的数组索引找到依赖模块引入
- 所有模块被打包进数组时，接受一个 module 和 require 方法，module.export 对外暴露自己，require 用来按索引引入所需模块
- 这样按照每个模块的依赖关系来构建起整个应用

##### loader 原理和实现

Loader 机制是 Webpack 最核心的机制，因为正是有了 Loader 机制，Webpack 才能足以支撑整个前端项目模块化的大梁，实现通过 Webpack 去加载任何你想要加载的资源。**每一个 loader 都是一个函数，接收的是需要处理的资源文件内容，输出的是处理完的结果。**

**webpack 的每一个资源处理完后都必须是 js 的代码格式，因为 webpack 只能按照 JavaScript 的语法解析模块。所以使用管道流的方式去处理文件最后生成 js code。**

any source -> loader1 -> loader2 -> javascript

其实管道的思想很多地方都在使用，gulp、redux 中间件、express 中间件、rxjs 等。

而为什么我们需要把所有的资源引入到 js 中呢，webpack 的设计思想是：

- 1.方便维护，当一个模块不需要时我们只需要去取这个模块，而不需要再去 html 去删除相关的引入资源。
- 2.webpack 以 js 作为入口文件，去按依赖进行模块的引用，所以不会导致资源的遗漏和缺失。

下面来具体实现一个 loader：

```javascript
//markdown-loader.js
const marked = require("marked");
moudule.export = (source) => {
  //具体的loader实现
  const html = marked(source);
  //将 html 字符串拼接为一段导出字符串的 JS 代码
  const code = `module.exports = ${JSON.stringify(html)}`;
  return code;
};

// ./webpack.config.js
module.exports = {
  entry: "./src/main.js",
  output: {
    filename: "bundle.js",
  },
  module: {
    rules: [
      {
        test: /\.md$/,
        // 直接使用相对路径
        use: "./markdown-loader",
      },
    ],
  },
};
```

##### plugin 原理和实现

**Webpack 插件机制的目的是为了增强 Webpack 在项目自动化构建方面的能力。**

我在这里先介绍几个插件最常见的应用场景：

- 实现自动在打包之前清除 dist 目录（上次的打包结果）；

- 自动生成应用所需要的 HTML 文件；

- 根据不同环境为代码注入类似 API 地址这种可能变化的部分；

- 拷贝不需要参与打包的资源文件到输出目录；

- 压缩 Webpack 打包完成后输出的文件；

- 自动发布打包结果到服务器实现自动部署。

```javascript
// ./webpack.config.js
const HtmlWebpackPlugin = require("html-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");
module.exports = {
  entry: "./src/main.js",
  output: {
    filename: "bundle.js",
  },
  plugins: [
    new CleanWebpackPlugin(), //清楚dist目录 避免缓存
    new HtmlWebpackPlugin({
      title: "Webpack Plugin Sample", //模板需要的title参数
      template: "./src/index.html", //自定义模板 然后去进行生成
    }),
    new CopyWebpackPlugin({
      patterns: ["public"], // 需要拷贝的目录或者路径通配符
    }),
  ],
};
```

##### plugin 实现

**Webpack 要求我们的插件必须是一个函数或者是一个包含 apply 方法的类，这个方法接收 compiler 对象参数，这个对象是 Webpack 工作过程中最核心的对象，包含所有配置信息。我们运用这个对象去把函数挂载到哪个钩子上。**

webpack 钩子：

- emit：Webpack 即将向输出目录输出文件时执行

```javascript
// ./remove-comments-plugin.js
class RemoveCommentsPlugin {
  apply(compiler) {
    //把这个插件挂载到emit钩子上
    compiler.hooks.emit.tap("RemoveCommentsPlugin", (compilation) => {
      // compilation => 可以理解为此次打包的上下文
      for (const name in compilation.assets) {
        if (name.endsWith(".js")) {
          const contents = compilation.assets[name].source(); //文件内容
          const noComments = contents.replace(/\/\*{2,}\/\s?/g, ""); //去除注释文件
          compilation.assets[name] = {
            //webapck插件规定的格式
            source: () => noComments,
            size: () => noComments.length,
          };
        }
      }
    });
  }
}
```

### 核心原理和机制

- 模块化打包：从入口文件开始，根据依赖关系，把整个项目中用到的资源进行一个梳理，形成一个依赖关系树。然后遍历整个树，根据树的依赖关系，把整个项目中散落的 js、css、img、font 等各种资源文件进行加载，根据配置找到每个资源对应的 loader 去处理这个模块，把打包结果放入 bundle.js 中，然后就可以完成整个项目的打包。插件机制是 Webpack 打包功能以外的能力，你可以通过钩子在打包的任意环节插入你想要处理的任务。

- 机制：
