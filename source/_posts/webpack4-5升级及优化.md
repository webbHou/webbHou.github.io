---
title: webpack4->5升级及优化
tags:
  - javascript
categories: js常见问题
date: 2022-11-02 18:10:36
---

# webpack4 升级 webapck5

```js
npm i react-dev-utils webpackbar friendly-errors-webpack-plugin -D

sudo npm i webpack webpack-cli webpack-dev-server webpack-merge -D
```

## 升级步骤

## 1、自定义开发环境

对于开发环境，我们更加灵活的自定义配置的方式

```js
const webpack = require("webpack");
const WebpackDevServer = require(\'webpack-dev-server\');

const compiler = webpack(config)
const devServer = new WebpackDevServer(compiler, devConfig)
devServer.listen(Config.port, host, err => {
  if (err) {
    return console.log(err);
  }
  console.log(chalk.cyan(\'Starting the development server...\
\'));
});
```

## 2、端口号(可能被占用)

> 随着项目越来越多，端口号可能会出现重复，所以启动项目时发现端口号已经被占用，需要找到合适的可用端口进行启动项目

```js
const portfinder = require(\'portfinder\');

portfinder.getPortPromise()
    .catch((err) => {
        console.log(\'webpack启动错误\', err)
    })
    .then((port) => {
   \t// 没有被占用的端口号
  \t\tconsole.log(port)
\t\t})
```

## 3、ip 链接

需求：由于移动端或者 pc 端，经常会拿 ip 链接进行手机的调试，或者将 ip 链接发送给对方进行联调，这时如果开发工具者控制台有这样的 ip 链接就很方便

```js
const FriendlyErrorsWebpackPlugin = require(\'friendly-errors-webpack-plugin\');

new MyFriendlyErrorsWebpackPlugin({
  compilationSuccessInfo: {
    messages: [
      \'App running at:\',
      `- Local:   ${chalk.cyan(newWorkUrl(host, port, Config.prefix))}`,
      `- Network: ${chalk.cyan(newWorkUrl(getNetworkIp(), port, Config.prefix))}`,
    ],
    notes: [
      \'Note that the development build is not optimized.\',
      `To create a production build, run ${chalk.cyan(\'npm run build\')}`,
    ]
  },
}),
```

```js
const os = require(\'os\')

function getNetworkIp() {
    let needHost = \'\'; // 打开的host
    try {
        // 获得网络接口列表
        let network = os.networkInterfaces();
        for (let dev in network) {
            let iface = network[dev];
            for (let i = 0; i < iface.length; i++) {
                let alias = iface[i];
                if (alias.family === \'IPv4\' && alias.address !== \'127.0.0.1\' && !alias.internal) {
                    needHost = alias.address;
                }
            }
        }
    } catch (e) {
        needHost = \'localhost\';
    }
    return needHost;
}

function prettyPrintHost(host) {
    const isUnspecifiedHost = host === \'0.0.0.0\' || host === \'::\';
    if (isUnspecifiedHost) {
        return \'localhost\';
    }
    return host
}

function newWorkUrl(host, port, prefix) {
    return `http://${prettyPrintHost(host)}:${port}/${prefix ? prefix : \'\'}`
}
```

### 问题：

antv 和 webpack5 之间有一些警告问题，一旦有了警告，那么 friendly-errors-webpack-plugin 就不会将我们的 ip 链接暴露出来，所以本地二次封装 friendly-errors-webpack-plugin 插件，达到目的

## 4、添加缓存

```js
cache: {
  type: \'filesystem\',  //\'memory\' | \'filesystem\'
  cacheDirectory: path.resolve(__dirname, \'../node_modules/.cache/webpack\'),
},
```

### 4.1、去除 dll 动态链接库

create-react-app 以及 vue-cli 在 webpack4.x 的时候就已经移除 dll,原因：就是 webpack4.x 的性能足够好，使用 dll 后收益非常小，而且 dll 还需要进行额外的繁琐配置

- [vue-cli 去除 dll 原因解释](https://github.com/vuejs/vue-cli/issues/1205)
- [create-react-app 去除 dll 原因解释](https://github.com/facebook/create-react-app/pull/2710)

结论：我们也去除 dll,配置中将所有关于 dll 的全部删除掉

## 5、关于图片和图标

去除 file-loader 和 url-loader

方式一：

```js
output:{
  assetModuleFilename: "images/[contenthash][ext][query]",
},
module:{
  rules:[
    { // 图标的转化
      test: /\\.(woff|woff2|eot|ttf|otf|svg)$/i,
      type: \'asset/resource\'
    },
    { // 图片的转化
      test: /\\.(jpe?g|png|gif|bmp)$/i,
      type: \'asset\',
      parser: {
        dataUrlCondition: {
          maxSize: 8192,// 8kb
        }
      }
    },
  ]
}

```

方式二：(采用)

```js
module:{
  rules:[
    { // 图标的转化
      test: /\\.(woff|woff2|eot|ttf|otf|svg)$/i,
      type: \'asset/resource\',
      generator: {
        filename: \'fonts/[contenthash][ext][query]\'
      }
    },
    { // 图片的转化
      test: /\\.(jpe?g|png|gif|bmp)$/i,
      type: \'asset\',
      parser: {
        dataUrlCondition: {
          maxSize: 8192,// 8kb
        }
      },
      generator: {
        filename: \'images/[contenthash][ext][query]\'
      }
    },
  ]
}
```

## 6、css 的路径问题

因为 css 和 images 是单独打包成一个独立的文件夹，那么 css 中寻找图片路径是从 css 目录开始找的，所以需要配置下

```js
isDevelopment ? {
  loader: "style-loader",
  options: { esModule: true },
} : {
  loader: MiniCssExtractPlugin.loader,
  options: { esModule: true, publicPath: \'../\' }, // 在原来配置的基础上添加publicPath属性
},
```

## 7、package 中的 scripts 改造

改造前:

```js
   "scripts": {
        "preview": "node scripts/preview.js",
        "ka": "terser ./js/utils/ka.js -m -c -o ./js/utils/ka-min.js",
        "dll": "webpack --config ./scripts/dll.webpack.js",
        "start": "cross-env NODE_ENV=development webpack-dev-server --hot --progress --colors --PACKAGE_ENV development --config ./scripts/webpack.dev.js",
        "local": "cross-env NODE_ENV=production webpack --PACKAGE_ENV local --progress --config ./scripts/webpack.prod.js",
        "test": "cross-env NODE_ENV=production webpack --PACKAGE_ENV test --progress --config ./scripts/webpack.prod.js",
        "pre": "cross-env NODE_ENV=production webpack --PACKAGE_ENV pre --progress --config ./scripts/webpack.prod.js",
        "build": "cross-env NODE_ENV=production webpack --PACKAGE_ENV production --progress --config ./scripts/webpack.prod.js"
    },
```

开发：npm run start

打包：npm run local/test/pre/build

改造后

```js
 "scripts": {
        "preview": "node scripts/preview.js",
        "ka": "terser ./js/utils/ka.js -m -c -o ./js/utils/ka-min.js",
        "dev": "node ./scripts/webpack.dev",
        "build:hr": "webpack --config ./scripts/webpack.prod",
        "start": "cross-env NODE_ENV=development PACKAGE_ENV=development npm run dev",
        "local": "cross-env NODE_ENV=production PACKAGE_ENV=local npm run build:hr",
        "test": "cross-env NODE_ENV=production PACKAGE_ENV=test npm run build:hr",
        "pre": "cross-env NODE_ENV=production PACKAGE_ENV=pre npm run build:hr",
        "build": "cross-env NODE_ENV=production PACKAGE_ENV=production npm run build:hr"
    },
```

开发：npm run start

打包：npm run local/test/pre/build

## 8、细节问题

### 8.1、webpack5 和 cnpm 有兼容性

> 因为 webpack5 里面的解析包是按照 npm 标准的@babel 这样的格式，如果违反规则直接失败，而 cnpm 是\_@babel 多了一个下划线

结论：避免使用 cnpm，使用 npm 和 yarn 的方式

### 8.2、webpack.NamedChunksPlugin 被废弃

```js
optimization: {
    moduleIds: \'deterministic\', // 模块名称的生成规则 -> 根据模块名称生成简短的hash值
    chunkIds: \'deterministic\', // 代码块名称的生成规则
}
```

### 8.3、watermark-dom

```js
# webpack4引用
import watermark from \'watermark-dom\'
watermark.loading({})
# webapack5
改成
import \'watermark-dom\'
watermark.loading({})
```

原因：webpack4 和 webpack5 对非【commonjs 和 esmodule】打包方式不一致，webpack5 是直接将其注入到 window 属性中

### 8.4、mac 启动项目默认打开一个 tab

举例：如果本地已经启动了 http://localhost:8080/web/ 的项目，并且在浏览器中打开了(不关闭)，如果我们将 8080 端口的项目关掉，在重新启动项目，则会在浏览器中找到刚才运行的项目页面开始编译，不会重新在浏览器中重新打开一个新的页面

```diff
const openBrowser = require(\'react-dev-utils/openBrowser\');

devServer.listen(Config.port, host, err => {
  if (err) {
    return console.log(err);
  }
  console.log(chalk.cyan(\'Starting the development server...\
\'));
+  openBrowser(`http://localhost:${port}/${Config.prefix}`)

});
```

### 8.5、清空控制台信息

原因：开发中，启动项目时，我们并不需要控制台这么多信息，本着简洁的原则需要：编译时间、以及项目链接

开发

```js
new WebpackDevServer(compiler, {
  overlay: false,
  quiet: true,
});
```

生产

```js
   stats: {
            all: false,
            errors: true,
            moduleTrace: true,
            logging: \'error\',
            assets: true,
        },
```

### 8.6 移除 clean-webpack-plugin

- 5.20 版本以后 output 新增特性 clean，用于清除 dist 文件

```js
{
  output: {
    clean: true, // Clean the output directory before emit.
  }
}
```

## 移除插件

- add-asset-html-webpack-plugin 不再需要
- open-browser-webpack-plugin 新插件替换
- url-loader、file-loader 对于图片/图标 webpack5 有新的写法
- hard-source-webpack-plugin 不再需要，有新的缓存方式
- clean-webpack-plugin 移除

## 添加插件

- react-dev-utils 辅助工具

- friendly-errors-webpack-plugin 启动提示

- webpackbar 启动进度条/编译时间

## 升级前后编译对比

| webpack 版本 | 首次编译(s) | 二次启动(s) | 修改文件编译(s) | 打包时间(s) | 打包体积 | 备注 |
| ------------ | ----------- | ----------- | --------------- | ----------- | -------- | ---- |
| 4.41.0       | 25s 左右    | 25s 左右    | 1s 左右         | 40 左右     | 2730kb   |      |
| 5.43.0       | 25s 左右    | 3s 左右     | 1s 左右         | 40 左右     | 2669kb   |      |
