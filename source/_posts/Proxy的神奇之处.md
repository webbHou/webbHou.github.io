---
title: Proxy的神奇之处
tags:
  - javascript
  - proxy
categories: js
date: 2020-12-05 14:15:11
---

#### 什么是Proxy

**Proxy对象可以让你为另一个对象创建一个代理，它可以拦截和重新定义该对象的基本操作。**

#### 如何使用

一个Proxy的创建有两个参数。

- target：你要创建代理的对象
- handler：定义要被拦截的操作

```javascript
var target = {
  name: 'webb',
  age: 23
}

const handler = {
  get: function(target,prop) { //拦截get操作
    if(prop === 'name'){
      return target['age']
    }else {
      return target['name']
    }
  }
}

const a = new Proxy(target,handler);

a.name //23
a.age //webb

```

[更多支持的自定义handler](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Proxy)
