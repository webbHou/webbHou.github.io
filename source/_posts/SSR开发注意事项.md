---
title: SSR开发注意事项
tags:
  - javascript
categories: js常见问题
date: 2022-11-02 18:21:22
---

#### 开发注意事项

#### 数据处理

==如果是 SSR 下就取页面的数据
context.state.home.newsList
否则从 state 取==

```
const mapStateToProps = state => ({
    list: webConfig.SSR?context.state.home.newsList:state.home.newsList,
    details: state.home.details,
});
```

#### Node 渲染数据

==把需要渲染的方法防盗 loadData 里面即可==

```
exportHome.loadData = (store) => {
   return store.dispatch(actions.getHomeList())

};
```

##### 如果要同事请求多个接口：（建议最好请求一个需要 SSR 的接口）

let fun=[store.dispatch(actions.getHomeList()),store.dispatch(actions.getDetails())]

#### 关于项目配置

文件路径：
==src/web.config.js==

```
//测试+预发（当前后端不在一台服务器时候）
if(process.env.npm_config_argv && (process.env.BUILD_ENV=="PRE" ||process.env.BUILD_ENV=="TEST")){
    let npm_config_argv=JSON.parse(process.env.npm_config_argv)
    let serverName = npm_config_argv.cooked[2]
    if(serverName=="--webtest1"){
        host="http://my-webtest.hou.com"
    }
    if(serverName=="--webtest2"){
        host="http://my-webtest1.hou.com"
    }
    if(serverName=="--webpre1"){
        host="http://api.hou-inc.com"
    }
    if(serverName=="--webpre2"){
        host="http://pre2-www.hou.com"
    }
}

const webConfig={
    "build":"job-wiki",  //项目别名
    "port":3001,         //项目端口
    "SSR":process.env.SSR_ENV=="true",
    "development":{
        host:"/",
        path:"/api/"
    },
    "production":{
        host:host,
        path:"/mock/365/"
    },
}
```

注意：该方案合适前后端不在同一个域名情况
同意域名 host:"/",
path:"/mock/365/" ==设置接口路径，根据实际情况配置==

#### Webpack

scripts/webpack.utils.js

```
const webConfig={
    "build":"job-wiki", //项目别名
}

```

自动转 REM(适合移动站)

```
  plugins: [
            require(\'precss\'),
            // require(\'postcss-pxtorem\')({
            //     rootValue: 20,
            //     unitPrecision: 5,
            //     propList: [\'width\', \'height\', \'line-height\', \'letter-spacing\', \'font*\', \'background*\', \'margin*\', \'padding*\'],
            //     selectorBlackList: [],
            //     replace: true,
            //     mediaQuery: false,
            //     minPixelValue: 0
            // })
        ],
```

异步请求多个接口

```
   getHomeList: (data) => async (dispatch, getState, Invoke) => {
        await Axios.all([
            Invoke.home.news({}, "GET", "json"),
            Invoke.home.details({}, "GET", "json")
        ])
         .then(Axios.spread(function (userResp, reposResp) {
                // 上面两个请求都完成后，才执行这个回调方法
                const list = userResp.data.data
                if (userResp.data.rescode == 0) {
                    dispatch(actions.setHomeList(list))
                }
                const data = reposResp.data
                if (data.rescode == 0) {
                    dispatch(actions.setDetails(data))
                }
            }))
    },
```

==注意：一定要先判断 rescode 的状态再 dispatch 否则页面会挂掉==

页面链接跳转不准用 Link 全部换成 A 标签

#### 打包命令

测试

```
npm run test --webtest1
npm run test --webtest2
```

预发

```
npm run pre --webpre1
npm run pre --webpre2
```

生产

```
npm run build
```

#### 两个全局变量注意用法

clientRender：是要用 npm start 开发模式用

条件内的代码打包后不会生效

```
 if(clientRender){
      let {getHomeList} =this.props
       getHomeList()
   }
```

serverRender

```
if(serverRender){
    //打包后会生效
}
```

SSR 模式开发（npm run dev）

缺点：静态资源实施编译，服务端渲编译慢，需要主动刷新页面才能看到效果
