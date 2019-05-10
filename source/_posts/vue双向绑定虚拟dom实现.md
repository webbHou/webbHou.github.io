---
title: 简易版vue双向绑定原理实现
tags:
  - javascript
categories: js常见问题
date: 2019-03-24 16:49:16
---


### 简易版vue双向绑定原理实现

#### 初始化数据遍历属性
```bash
function observe(obj) {
    // 判断类型
    if (!obj || typeof obj !== 'object') {
        return
    }
    Object.keys(obj).forEach(key => {
        defineReactive(obj, key, obj[key])
    })
}
```

#### 对属性进行劫持并添加订阅
```bash
function defineReactive(obj, key, val) {
    // 递归子属性
    observe(val);
    let dp = new Dep();   //一个属性的公共订阅
    Object.defineProperty(obj, key, {
        enumerable: true,
        configurable: true,
        get: function reactiveGetter() {
            console.log('get value',dep)
            if(dep) dp.addsub(dep); //触发getter时添加实例到订阅
            return val
        },
        set: function reactiveSetter(newVal) {
            console.log('change value')
            val = newVal;
            dp.notify();  //set时执行订阅更新
        }
    })
}   
```  



#### 发布订阅函数实现
 ```bash
 //发布订阅
class Dep{
  constructor(){
      this.subs = [];
  }
  addsub(sub){  //订阅添加实例
      this.subs.push(sub);
      dep=null;
  }
  notify(){  //发布通知所有订阅执行回调
      this.subs.forEach(v=>{
          v.update()
      })
  }
}
 ```

#### 手动触发getter添加到订阅
```bash
data = { name:'web' }
observe(data);  //初始化数据
//属性监听器
class Watcher{
    constructor(obj,key,cb){
        dep=this;
        this.cb = cb;
        this.obj = obj;
        this.key = key;
        this.value = obj[key];   //触发getter  
    }
    update(){
        this.value = this.obj[this.key];
        this.cb(this.value );
    }
}
new Watcher(data,'name',update)  //data,key,cb 手动添加订阅   
//vue中底层模版解析时 会自动触发getter添加订阅
 ```