---
title: 手写实现一个promise
tags:
  - javascript
  - 面试
categories: js常见问题
date: 2019-01-08 13:58:16
---


**手写简单实现一个promise现在已经成了前端面试进阶必问之一的题目，接下来我们就简单实现一个promise**


### 基础版

我们知道一个promise有三种状态，初始状态pending，成功状态resolve，失败状态reject，pending可在一定条件下转化为resolve或reject，并不可逆。
```bash
定义三种状态
const PENDING = 'pending'; //初始状态 可转换为resolve或reject 不可逆
const RESOLVE = 'resolve'; //成功状态 
const REJECT = 'reject'; //失败状态
```

```bash
promise是一个可以被new创建的对象，因此我们需要通过对象继承的方法去创建，接受一个函数作为参数，该函数会立即执行
function MyPromise(constructor){
    const that = this;
    that.status = PENDING; //定义初始状态
    that.value = undefined;  //记录成功的返回值
    that.reason = undefined; //记录失败的返回值

    this.resolve = function(call){   //成功调用的函数 实例调用
        if(that.status === PENDING){
            that.status = RESOLVE;  //改变初始状态为RESOLVE
            that.value  = call;
        }
    }
    this.reject = function(call){   //失败调用的函数 实例调用
        if(that.status === PENDING){
            that.status = REJECT;  //改变初始状态为REJECT
            that.reason = call;
        }
    }
    try{
        constructor(this.resolve,this.reject);  //立即执行该函数，接受两个回调函数参数
    }catch(e){
        this.reject(e)
    }
}
```

```bash
接受两个回调作为参数，状态成功时执行onResolved 失败时执行onRejected
MyPromise.prototype.then = function(onResolved,onRejected){
  const that = this;
  switch(that.status){
    case RESOLVE:
      return onResolved(this.value);
    case REJECT:
      return onRejected(this.reason);
  }
}
```

```bash
let p = new MyPromise((resolve,reject)=>{
  ajax(res=>{
    success:resolve(res),
    fail:reject(res)
  })
})
p.then(value=>{
  console.log(value)
},reson=>{
  console.log(reason)
})
```

**上述只是简单是promose实现思路，不能进行异步调用，返回值也不是promise，所以不符合Promise / A+ 规范，下面完成根据规范实现下加强版**

### 加强版