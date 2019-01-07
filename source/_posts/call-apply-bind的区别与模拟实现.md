---
title: call-apply-bind的区别与模拟实现
tags:
  - javascript
  - 面试
categories: js常见问题
date: 2018-09-25 16:24:16
---

**call、apply、bind方法的区别一般会是前端面试的必考题目之一。可是你以为会了这个就可以了？那说明你还是太年轻，前端的水还是很深的。只有你没学到的，没有问不到的。好了，废话不多说，下面分别说一下三者的区别的和模拟实现。**

### call和apply区别

call 和 apply 都是为了解决改变 this 的指向。作用都是相同的，只是传参的方式不同。
call方法接受一串参数，第一个是改变this指向的对象，从第二个开始后面的全是它的参数。
apply方法只接受两个参数，同样第一个是改变this指向的对象，第二个开始与call不同，接受的是一个数组。

### 接下来分别模拟实现这两个方法:
#### call
```bash
两个都是作为函数的方法存在，所以用给函数添加原型方法的思路实现。
Function.prototype.myCall = function(context){
    if(typeof this !=== 'function') return
    const context = context || window;
    context.fn = this; //给新对象添加函数为该方法，执行后删除
    const args = [...arguments].slice(1);
    const result = context.fn(args);
    delete context.fn;
    return result;
}
```

#### apply
```bash
同理，apply也是这种思路，只不过参数有一点点的不同
Function.prototype.myApply = function(context){
    if(typeof this !=== 'function') return
    const context = context || window;
    context.fn = this; //给新对象添加函数为该方法，执行后删除
    let result;
    if(arguments[1]){
      result = context.fn(...arguments[1]);
    }else{
      result = context.fn();
    }
    delete context.fn;
    return result;
}
```

### bind与apply和call的区别和实现

bind区别于apply和apply的是只改变了原函数的this指向，并没有执行，返回的是一个函数。传参和call相同，接受一串参数。所以实现上也有所不同。

#### bind
```bash
bind只改变了原函数的this指向，并没有执行，返回的是一个函数,所以我们可以用apply来模拟
Function.prototype.myBind = function(context){
    if(typeof this !=== 'function') return
    let _this = this;
    let args = [...arguments].slice(1);
    return F(){
      // 因为返回了一个函数，我们可以 new F()，所以需要判断
      if (this instanceof F) {
        return new _this(...args, ...arguments)
      }
      return _this.apply(context,args.concat(arguments))
    }
}
```