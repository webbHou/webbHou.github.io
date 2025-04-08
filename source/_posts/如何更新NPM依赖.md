---
title: 如何更新NPM依赖
tags:
  - NPM
categories: js常见问题
date: 2022-12-21 10:20:31
---

#### npm outdated

npm 内置 该命令将检查每个已安装的依赖关系，并将当前版本与 npm registry 中的最新版本进行比较。它在终端打印出一个表格，概述了可用的版本。

- Current：是当前安装的版本。
- Wanted：是根据 semver 范围内的软件包的最大版本。
- Latest：是在 npm registry 中被标记为最新的软件包版本。

npm update 命令会更新到 wanted 版本

#### npm-check-updates

npm install -g npm-check-updates 全局安装

ncu 类似 npm outdated 会列出所有依赖可升级的版本 不同类型根据颜色标注

- Red （显示红色） = major （主版本，或者说是大版本）
- Cyan （显示青色） = minor（次要版本）
- Green（显示绿色） = patch （补丁版本）

ncu --target [patch, minor, latest, newest, greatest] 指定不同类型进行升级

ncu --interactive 自定义选择升级
ncu --interactive --format group 根据类型分组列出 进行选择升级

#### npm 安装本地或私有 git 源包

- 安装本地包 file 协议 yarn add file:./config 更新 或 yarn install

```javascript
{
    "dependencies": {
        "config": "file:./config"
    }
}

```

- 安装私有 git 源 yarn upgrade yii-es6-amd 更新 或 yarn install

```javascript
{
  "dependencies": {
    "yii-es6-amd": "git+https://git@github.com/yiifaa/yii-es6-amd.git"
  }
}
```

#### 使用 npm link 引入本地 npm 模块进行调试

- 当项目和模块在 相同 目录下，可以使用相对路径，只需 link 一次

```javascript
npm link ../xx-module
```

- 当项目和模块在 不同 目录下

```javascript
// xx-module为文件名
cd ../xx-module
npm link

cd your-project
npm link your-ui-lib // your-ui-lib 为模块名
```


#### npm发布如何只发布打包文件

- 白名单
  在package指定files字段，列出要包含在发布包中的文件和目录(package.json、README.md、LICENSE 和 main 字段指向的文件默认会被包含)

- 黑名单
  新建.npmignore文件，在文件中列出要忽略的文件和目录，如果有.gitignore，npm 默认会使用 .gitignore。当发布的内容与 Git 忽略的内容不同，必须显式创建.npmignore文件。