---
title: 面试秘籍-原生js篇
tags:
  - javascript
categories: 面试
date: 2019-02-19 11:53:44
---

### 原型/构造函数/实例

- 原型(prototype)：包含实例的构造函数和原型方法的对象，用于实现实例的属性继承。可以理解成对象的爹，每个JavaScript对象中都包含一个__proto__ (非标准)的属性指向它爹(该对象的原型)，可obj.__proto__进行访问。
- 构造函数：可以通过new来 新建一个对象 的函数，每个函数都可以是构造函数。一般构造函数的首字母大写 构造函数的prototype也指向原型 构造函数的_proto_指向函数原型。
- 实例：通过构造函数new出来的对象 实例的_proto_指向原型 实例的constructor指向构造函数 构造函数的prototype也指向原型 原型的constructor只想构造函数

### 原型链

原型链由原型对象组成，每个对象都有_proto_属性，指向创建该对象的构造函数的原型，_proto_属性把对象链接组成原型链，是一个用来实现继承和共享属性的有限的对象链。

- 属性查找机制：当查找对象的属性时，如果实例上不存在该对象，则沿着原型链往上一级查找，找到则输出否则继续往上一级查找，直到顶级原型对象Object.prototype，没有则返回undefined
- 属性修改机制：只会修改该实例的属性，没有则添加该属性，如果需要修改原型的属性时，则可以用: b.prototype.x = 2；但是这样会造成所有继承于该对象的实例的属性发生改变。

### 作用域

作用域其实可理解为该上下文中*声明的变量和声明的作用范围*。可分为*块级作用域* 和 *函数作用域*。

#### 特性

- 声明提前: 一个声明在函数体内都是可见的, 函数优先于变量
- 非匿名自执行函数，函数变量为 只读 状态，无法修改

```bash
const foo = 1
(function foo() {
    foo = 10  // 由于foo在函数中只为可读，因此赋值无效
    console.log(foo)
}()) 

// 结果打印：  ƒ foo() { foo = 10 ; console.log(foo) }
```

### 作用域链

作用域链可以理解为一组对象列表，包含*父级和自身的变量对象*，因此我们便能通过作用域链访问到父级里声明的变量或者函数。

### 闭包

闭包：当函数A被摧毁的情况下，返回出的子函数中依然保存着父级的变量和作用域，因此可以访问父函数的变量对象，这样的函数叫做闭包。
应用：函数柯里化、第三方库(避免全局污染)

#### 经典问题
```bash
for(var i=0;i<6;i++){
  setTimeOUt(()=>{
    console.log(i)  //setTimeOut是异步函数会在循环结束后执行 这时所以i是6
  },i*1000)
}
```
#### 解决办法1 闭包
```bash
for(var i=0;i<6;i++){
  (function(j) {
    setTimeOUt(()=>{
      console.log(j) 
    },j*1000)
  })(i)
}
```

#### 解决办法2 setTimeOUt第三个参数
```bash
for(var i=0;i<6;i++){
  setTimeOUt(i=>{
    console.log(i) 
  },i*1000,i)
}
```

#### 解决办法2 let创建块级作用域
```bash
for(let i=0;i<6;i++){
  setTimeOUt(()=>{
    console.log(i) 
  },i*1000)
}
```

### script引入方式

- script 标签静态引入 遇到标签加载并执行
- js 动态插入
- script async 与后面元素并行（加载并执行，加载完就执行，并不按声明顺序）
- script defer 与后面元素并行 (加载但不执行，等所以元素解析完后执行，DOMContentLoaded事件触发前执行，按声明顺序执行)

### 拷贝

#### 浅拷贝: 只会拷贝第一层，深层的修改依然会有影响
- Object.assign({},obj);
- ...展开符

### 深拷贝
- JSON.parse(JSON.stringify(obj)): 性能最快 （值为函数或undefined时，无法拷贝）
- 递归

### new运算符的执行过程
- 新生成一个对象
- 新对象的_proto_指向构造函数的prototype
- 绑定this并执行构造函数
- 返回该对象


### 继承的方式
```bash
function Anmail(){
  this.specil = '动物‘
}
```

- 父对象构造函数绑定：使用call或apply方法，将父对象的构造函数绑定在子对象上，即在子对象构造函数中加一行：

缺点：
  - 只能继承属性，不能继承原型方法
  - 无法实现复用，每个子类都有父类实例函数的副本，影响性能
```bash
function Cat(name,age){
  Anmail.call(this,arguments)
  this.name = name;
  this.age = age;
}
var cat1 = new Cat("大毛","黄色");
alert(cat1.species); // 动物
```

- 修改prototype指向：把子对象的prototype指向父对象的实例，则有了父对象的属性，但只能为静态 

缺点：**(实例对引用类型的修改会影响原数据)**

```bash
function Cat(name,age){
  this.name = name;
  this.age = age;
}
Cat.prototype = new Anmail();
Cat.prototype.constructor = Cat; //最后把子对象构造函数指向本身
```

- 直接继承prototype：把子对象的prototype指向父对象的prototype
```bash
function Cat(name,age){
  this.name = name;
  this.age = age;
}
Cat.prototype = Anmail.prototype;
Cat.prototype.constructor = Cat; //会修改Anmail对象的构造函数指向
```

- 利用空对象作为中介:对直接继承的修改
```bash
var F = function(){};
F.prototype= Anmail.prototype;
Cat.prototype = new F();
Cat.prototype.constructor = Cat;
Cat.uber = Parent.prototype; //为了实现继承的完备性 指向父级的prototype
```

- 拷贝继承
```bash
function(parent,child){
  var p = parent.prototype;
  var c = parent.prototype;
  for(var i in p){
    c[i] = p[i]
  }
  c.uber = p;
}
```

- Es6 class 继承
```bash
  class Cat extends Anmail{

  }
```

### 隐式类型转换

- 除+以外的运算都先转为数值
- +有一端为字符串则都转完字符串 否则为数值
- [1].toString === '1'   先转为数值再转为字符串
- var a = {} a.toString() === '[object object]'  


### 类型判断

* Object.prototype.toString.call(obj): 原理：调用Object的原型的toString方法（返回对象的具体类型）

* typeof：是对对象的二进制进行区分的  因为不同对象的在底层表示为二进制的不同  这也是为什么typeof null===‘object’的原因

* instance：是在该对象的原型链上进行查找是否有与之匹配的原型对象


### 模块化

- Es6： import/export
- commonjs：require/exports/module.export

#### require和import的区别

- require支持*动态导入*，import不支持，正在提案(babel 下可支持)
- require是*同步导入*，import属于*异步导入* （require执行时导入，import编译时导入）
- require是*值拷贝*，导出值变化不会影响导入值；import指向*内存地址*，导入值会随导出值而变化 （但目前都是值拷贝，babel最终也会把import转换为require）

### 防抖与节流

防抖和节流是对*高频触发操作*的优化方式，会极大的提升性能

- 防抖 (debounce): 将多次高频操作优化为只在最后一次调用执行，通常使用的场景是：用户输入，只需在输入完成后做一次输入校验即可。
```bash
function debounce(fun,wait=5000,immediately=true){

  let timer,context,args;

  return function(...arumens){
    context = this;
    args = arumens;

    if(immediately && !timer){
      fn.apply(context,args)
    }

    if(timer) clearTimeout(timer);

    timer = setTimerOut(()=>{
      timer = null;
      fun.apply(context,args);
    },wait)

  }

}
```
- 节流 (throttle): 每隔一段时间后执行一次，也就是降低频率，将高频操作优化成低频操作，通常使用场景: 滚动条事件 或者 resize 事件，通常每隔 100~500 ms执行一次即可。 
```bash
function throttle(func,wait=5000,immediately=true){
  let timer,context,args,first=immediately;

  return function(...arguments){
    context = this;
    args = arguments;
    if(first){
      fn.apply(context,args);
      first=false;
    }
    if(!timer){
      timer = setTimeOut(()=>{
        timer=null;
        fn.apply(context,args)
      },wait)
    }
  }
}
```

### 回流和重绘

**当js操作dom时，会引发js引擎与渲染引擎的交互，多次的交互极大的损失性能，所以现代框架中虚拟dom来模拟，多次的操作合并为一次。当元素的样式发生变化时，浏览器需要触发更新，重新绘制元素。这个过程中，有两种类型的操作，即重绘与回流。**

- 重绘(repaint):当元素的样式改变而不影响布局时，浏览器将使用重绘对元素进行更新，只是UI变现层的更新，因此**损耗较少**
- 回流(reflow):当元素的尺寸、结构或属性发生改变时，引发浏览器的重新渲染，称之为回流。浏览器需要重新计算，计算后还要重新布局，然后GPU绘制页面，因此对性能损耗较大，这也是性能优化重要的一点
  * 容易引发回流的操作
    + 页面初次渲染
    + 浏览器窗口大小改变
    + 元素尺寸、位置、内容发生改变
    + 元素字体大小变化
    + 添加或者删除可见的 dom 元素
    + 激活 CSS 伪类（例如：:hover）
    + 查询某些属性或调用某些方法

**回流必定触发重绘，而重绘不一定触发回流，查询某些属性或调用某些方法**

- 减少回流的css实践（优化性能）
  * css
    + 避免使用display:table布局
    + 将动画应用到脱离文档流的元素上(如absolute，fixed)
  * js
    + 避免频繁操作样式，将多次汇总为一次
    + 尽量用添加class进行修改
    + 减少dom操作次数，可使用字符串一次插入进去
    + 多次操作一个元素样式时，先display：none再操作

### http/https

- http协议:
  * 1.0
    + 无法复用 完成就断开 需要重新连接和Tcp三次握手
    + head of line blocking 阻塞 导致请求之间影响
  * 1.1
    + 长连接keep-alive
    + 断点续传
    + cache 缓存
      * cache-control 设置最大缓存时间 优先
      * expires  过期时间判断
      * Last-Modified 最后一次修改时间 
      * E-tag 文件唯一标示 优先
  * 2.0
    + 多路复用
    + 服务端推送(websocket)
- https协议:
  * 证书(公钥)
  * ssl加密
  * 443端口

- 缓存策略：强缓存和协商缓存
  * 强缓存：浏览器判断缓存是否过期，没过期直接使用强缓存
    - cache-control：设置最大缓存过期时间(秒) 优先于expires
    - expires：设置到期的时间(服务器时间) **客户端可能和服务器时间不同**
  * 协商缓存：当缓存过期时，使用强缓存
    - Last-Modified：最后一次修改时间 Last-Modified(response) & If-Modified-Since (request，上一次返回的Last-Modified)
      + 如果一致，则直接返回 304 通知浏览器使用缓存
      + 不一致 服务器返回新资源
    - 唯一标识方案：Etag(response 携带) & If-None-Match(request携带，上一次返回的 Etag): 服务器判断资源是否被修改：
      + 修改了则返回新的资源
      + 如果相同则返回304浏览器使用缓存

### http状态码

- 1**：接受，继续处理
- 200：成功，并返回数据
- 201：已创建
- 202：已接受
- 203：成功，并返回数据
- 204：成功，无内容
- 205：成功，重置内容
- 206：成功，部分内容
- 301：重定向
- 302：临时移动，可使用原url
- 304：资源未修改，可使用缓存
- 305：需要代理访问
- 400：语法错误
- 401：需要身份认证
- 403：拒绝请求
- 404：资源不存在
- 500：服务器错误

### get/post区别

- get：可以被缓存/请求长度受限制(4k)/会被历史记录/不会修改资源
- post：安全/数据传输大/更多编码类型


### cookie和seesion和localstorage的区别

- 时效性： cookie一般有过期时间 localstorage不清楚永远存在 seesion窗口打开期间
- 存储大小：coookie一般4K左右 localstorage session 5M左右
- 服务器交互：cookie会在交互时在请求头携带 其他不会


### Node的EventLoop的6个阶段

- timer阶段：执行到期的定时器setTimeout和setInterval的回掉
- I/O阶段：执行上轮循环残留的callback
- 

### 跨域

- JSONP：利用script标签不受限制的特点，但只支持get请求
- 设置CORS：Access-Control-Allow-Origin：*
- postMessage：window.postMessage
- 设置domain：同一主域名下

### 安全

- XSS攻击：跨站脚本：利用浏览器的输入输出漏洞进行脚本攻击
  * 危害
    + 窃取cookie信息
    + 监听用户行为
    + 修改dom，伪造登录页面
  * 类型
    + 存储型：黑客输入脚本然后存入该站点数据库，用户访问时请求就包含了恶意脚本，执行就会被窃取用户信息
    + 反射型：该类型不需要存储在数据库，恶意链接会携带js脚本，然后在页面中执行，触发恶意操作
    + 基于DOM：通过手段修改dom，html传输中或使用中被劫持，然后修改dom
  * 防范
    + 重要数据httpOnly
    + 对页面上的输入和输出内容进行转义或过滤
    + 利用CSP（同源策略）：禁止加载或者执行其他域下的脚本
- CSRFF：跨站伪装请求：访问第三方站点时，利用用户的登录态调取接口
  * 危害
    + 窃取cookie信息
    + 伪装请求来让操作用户数据或财产
  * 类型
    + 伪造get请求（img\src等标签自动发起请求）
    + 伪造post请求（表单自动提交）
    + 吸引用户点击第三方站点链接
  * 防范
    + get 不修改数据
    + 禁止第三方网站发送cookie：设置cookit的sameSite（Strict|Lax|None）
    + CSRF Token：第一次请求下发CSRF Token、接口请求携带并校验
    * 设置白名单，不被第三方请求
    + 请求来源校验（origin、refer：安全原因有时候没有）

### 虚拟dom diff原理和实现

- 真实dom初始化为虚拟dom树
- 树的diff，深度遍历，添加索引(方便渲染差异)，同层对比 输出（diffList，diffchildren，diffprops）
  * 没有新的节点，返回
  * 有新的节点，tagname和key相同，对比属性，遍历子节点
    + 对比属性(新旧属性列表)
      * 是否有删除属性
      * 是否属性值修改
      * 是否有新加属性
    + 对比列表(新旧列表)
      * 是否有删除
      * 是否有新增
      * 是否移动
  * tagname和key不同，直接替换该节点
- 渲染差异：根据前后虚拟dom的差异节点渲染真实dom
  * 遍历patchs， 把需要更改的节点取出来
  * 局部更新dom

- js模拟dom对象的实现
```bash
class Elemnet{
  constructor(tags,props,children,key){
    this.tags = tags;
    this.props = props;
    if(Array.isArray(children)){
      this.children = children
    }else if(isString(children)){
      this.key = children;
      this.children = null;
    }
    if(key) this.key = key;
  }

  render(){
    var root = this._createHtml(
      this.tags,
      this.props,
      this.children,
      this.key
    )
    document.body.appendChild(root)
  }

  create(){
    return this._createHtml(
      this.tags,
      this.props,
      this.children,
      this.key
    )
  }

  _createHtml(tags,props,children,key){
    let el = document.createElement(tags);
    for(const key in props){
      if (props.hasOwnProperty(key)) {
        let value = props[key];
        el.setAttribute(key,value)
      }
    }
    if(key) el.key = key
    if(children){
      children.forEach(e=>{
        let child;
        if(e instanceOf Element){
          e = this._createHtml(e)
        }else{
          child = document.createTextNode(e);
        }
        el.appendChild(child)
      })
    }
    return el
  }
}
```


### diff算法实现

``` bash 
class diff{
  constructor(){
    let pathchs = {}; //收集差异
    difers(newTrees,oldTrees,0,pathchs);
    return pathchs;
  }
}

function difers(){

}
```

### vue3.0中proxy相比于defineProperty的优点

- defineProperty只能对属性进行劫持，所以需要深度遍历整个对象。proxy直接对整个对象进行拦截
- 不能监听到数组的变化  proxy原生支持监听数组


### react-redux和mobx的区别

- mobx 入门更简单  redux相对较难
- mobx异步更加方便  redux需要中间件来支持
- mobx是对数据的引用 可直接修改数据的状态  redux 是immutable的思想 每次返回新的对象 需要数据流的方式去修改状态
- 正是因为这个 所以mobx更适合小项目 没有很多数据的管理 大型项目多人协作开发会容易引发冲突



### for..in和for..of的区别

* for..in：会对对象的key值进行遍历 如果是数组会遍历下标(多维数组不可遍历)  
```bash
当给数组添加属性时，也会被遍历
let arr = [1,2,3];
arr.name = 'w';
for(let i in arr){
  console.log(i)   //0,1,2,name
}
```

* for..of：会对对象的值进行遍历 还可以通过下标拿到子属性的值 只会遍历集合本身元素 



### 位运算

* &位与运算

1&2 => 0001&0010 => 0
15&14 => 1111&1110 => 1110  取都等于1的公共位

* <<位左移运算
1<<2 => 0001左移两位 => 0100 => 4


### 模块化和组件化

* 模块化：是从逻辑上的划分，考虑代码的组织
* 组件化：是从UI上的划分，考虑代码的复用