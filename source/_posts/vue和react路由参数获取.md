---
title: vue和react路由参数获取
tags:
  - javascript
  - vue-router
  - react-router
categories: js常见问题
date: 2017-11-17 11:30:20
---

## vue获取路由参数的方式

vue可以通过获取当前路由来获取,可以通过路由的监控触发事件来进行数据请求变更
```bash
this.$route.params
watch:{
  //进行路由的监控触发事件
  '$route': '事件名'
}
```

## react获取路由参数的方式

react把路由参数作为prop进行传递,子组件只需要获取当前组件的props即可
```bash
this.props.params
```
