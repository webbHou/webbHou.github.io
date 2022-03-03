---
title: Remach学习和实践
tags:
  - rematch
  - javascript
categories: js常见问题
date: 2022-01-05 11:02:42
---

#### 什么是rematch

#### 为什么不是redux

在redux中状态管理的流程如下:
1.首先需要页面发起一个dispatch函数，接受一个action参数，
2.state中定义这个action 并导入都页面中
3.action中对异步或逻辑进行处理，然后再dispatch一个action
4.定义reducer然后 收集action，并处理
5.createStore，对所有的reducer进行合并处理，并添加中间件

所有因为redux操作的复杂性，很多重复的步骤可以省略，rematch就是对redux进行了二次封装，借鉴了dva的风格重新优化了流程，多余的action types，action creators，switch 语句或者thunks。使得我们开发时减少了很多重复的步骤和流程。

一个常见的rematch如下：

```js
import { init } from '@rematch/core'

// model
const count = {
  state: 0,
  reducers: {
    upBy: (state, payload) => state + payload
  },
  effects: {
    async add(payload, rootState) {
      // await 异步操作
      this.upBy(payload)
    }
  }
}

// 初始化store
init({
  models: { count }
})
// 调用
props.dispatch.count.upBy(routerInfo)
```
