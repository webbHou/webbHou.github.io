---
title: 面试秘籍-原生js篇
tags:
  - javascript
categories: 面试
date: 2019-02-19 11:53:44
---

#### 获取元素位置和大小的方法和区别

- offset
  - offsetTop：获取元素顶部距离定位父级的距离 元素外边框至定位父级上内边框的距离。外边距+父级上内边距
  - offsetLeft：获取元素左边距离定位父级的距离 元素外边框至定位父级左内边框的距离。外边距+父级左内边距
  - offsetWidth/offsetHeight：获取元素在页面上可见的空间大小，不包含隐藏滚动区域 实际宽度 + 左右内边距 + 左右边框

- client
  - clientLeft/clientTop：实际获取的就是元素的边框宽度
  - clientWidth/clientHeight：获取元素内容和内边距占的大小 不包含隐藏滚动区域  内容区域+内边距-滚动条宽度

- scroll
  - scrollLeft和scrollTop：获取当前元素的滚动位置 隐藏在内容区域左侧和上方的像素
  - scrollWidth和scrollHeight：获取包含滚动内容的元素的大小

- getBoundClientRect：
  - top/bottom：顶部/底部距离视口上边的距离  height = bottom - top
  - left/bottom：左侧/右侧距离视口左边的距离  width = right - left

- getComputedStyle：获取元素样式
  - width/height: 实际宽高 不包含内外边距和边框

##### 如何获取元素到文档顶部的距离

1.offsetTop

```javascript
function getTop(ele){
  let top = ele.offsetTop;
  var parent = ele.offsetParent;
  while(parent){
    top += parent.offsetTop;
    parent = parent.offsetParent;
  }
  return top;
}
```

2.getBoundingClientRect().top + offsetParent.scrollTop

```javascript
function getTop(ele){
  let top = ele.getBoundingClientRect().top;
  var parent = ele.offsetParent;
  while(parent){
    top += parent.scrollTop;
    parent = parent.offsetParent;
  }
  return top;
}
```

##### 判断一个元素是不是包含另一个元素

parentele.contains(ele)

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

#### 解决办法2 setTimeout第三个参数

```javascript
for(var i=0;i<6;i++){
  setTimeout(i=>{
    console.log(i)
  },i*1000,i)
}
```

#### 解决办法2 let创建块级作用域

```javascript
for(let i=0;i<6;i++){
  setTimeout(()=>{
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

```javascript
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

```javascript
function Cat(name,age){
  this.name = name;
  this.age = age;
}
Cat.prototype = new Anmail();
Cat.prototype.constructor = Cat; //最后把子对象构造函数指向本身
```

- 直接继承prototype：把子对象的prototype指向父对象的prototype

```javascript
function Cat(name,age){
  this.name = name;
  this.age = age;
}
Cat.prototype = Anmail.prototype;
Cat.prototype.constructor = Cat; //会修改Anmail对象的构造函数指向
```

- 利用空对象作为中介:对直接继承的修改

```javascript
var F = function(){};
F.prototype= Anmail.prototype;
Cat.prototype = new F();
Cat.prototype.constructor = Cat;
Cat.uber = Parent.prototype; //为了实现继承的完备性 指向父级的prototype
```

- 拷贝继承

```javascript
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

```javascript
  class Cat extends Anmail{

  }
```

### 隐式类型转换

- 除+以外的运算都先转为数值
- +有一端为字符串则都转完字符串 否则为数值
- [1].toString === '1'   先转为数值再转为字符串
- var a = {} a.toString() === '[object object]'  

### 类型判断

- Object.prototype.toString.call(obj): 原理：调用Object的原型的toString方法（返回对象的具体类型）

- typeof：是对对象的二进制进行区分的  因为不同对象的在底层表示为二进制的不同  这也是为什么typeof null===‘object’的原因

- instance：是在该对象的原型链上进行查找是否有与之匹配的原型对象

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

```javascript
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

```javascript
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
  - 容易引发回流的操作
    - 页面初次渲染
    - 浏览器窗口大小改变
    - 元素尺寸、位置、内容发生改变
    - 元素字体大小变化
    - 添加或者删除可见的 dom 元素
    - 激活 CSS 伪类（例如：:hover）
    - 查询某些属性或调用某些方法

**回流必定触发重绘，而重绘不一定触发回流，查询某些属性或调用某些方法**

- 减少回流的css实践（优化性能）
  - css
    - 避免使用display:table布局
    - 将动画应用到脱离文档流的元素上(如absolute，fixed)
  - js
    - 避免频繁操作样式，将多次汇总为一次
    - 尽量用添加class进行修改
    - 减少dom操作次数，可使用字符串一次插入进去
    - 多次操作一个元素样式时，先display：none再操作

### http/https

- http协议:
  - 1.0
    - 无法复用 完成就断开 需要重新连接和Tcp三次握手
    - head of line blocking 阻塞 导致请求之间影响
  - 1.1
    - 长连接keep-alive
    - 断点续传
    - cache 缓存
      - cache-control 设置最大缓存时间 优先
      - expires  过期时间判断
      - Last-Modified 最后一次修改时间
      - E-tag 文件唯一标示 优先
  - 2.0
    - 多路复用
    - 服务端推送(websocket)
- https协议:
  - 证书(公钥)
  - ssl加密
  - 443端口

- 缓存策略：强缓存和协商缓存 一般对不经常修改资源设置强缓存(图片，字体等) js|html等设置协商缓存
  - 强缓存：浏览器判断缓存是否过期，没过期直接使用强缓存
    - cache-control：设置最大缓存过期时间(秒) 优先于expires
    - expires：设置到期的时间(服务器时间) **客户端可能和服务器时间不同**
  - 协商缓存：当缓存过期时，使用强缓存
    - Last-Modified：最后一次修改时间 Last-Modified(response) & If-Modified-Since (request，上一次返回的Last-Modified)
      - 如果一致，则直接返回 304 通知浏览器使用缓存
      - 不一致 服务器返回新资源 **同一秒修改和获取文件时，获取不到最新**
    - 唯一标识方案：Etag(response 携带) & If-None-Match(request携带，上一次返回的 Etag): 服务器判断资源是否被修改：
      - 修改了则返回新的资源
      - 如果相同则返回304浏览器使用缓存

- 缓存失效：有时候更新了文件，但客户端获取不到最新
  - 文件名后缀添加版本号 **.js?version=1.00
  - 现代化构建工具打包 hash值文件名

- 缓存配置

```js
location / {

  # 其它配置
  ...

  if ($request_uri ~* .*[.](js|css|map|jpg|png|svg|ico)$) {
    #非html缓存1个月
    add_header Cache-Control "public, max-age=2592000";
  }

  if ($request_filename ~* ^.*[.](html|htm)$) {
    #html文件使用协商缓存
    add_header Cache-Control "public, no-cache";
  }
}
```

- 缓存存储位置

在浏览器的network中每个加载文件的size可以看到 如果是memory cache、disk cache、Service Worker则来自于缓存，否则为服务端请求文件
缓存查找策略为先内存后硬盘

- memory cache：内存缓存
- disk cache：硬盘缓存
- Service Worker：浏览器缓存

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

### script的src和img的src跨域的区别

原理是相同的，都是利用标签的src属性可以跨域请求的特点，但是具体的实现不同。
使用img标签不能访问服务器返回的响应内容，也就是说只能单向的发送get请求。
而使用script标签实现的jsonp跨域可以将服务器响应文本以函数参数的形式返回，浏览器解析js代码时直接就执行了。

### 安全

- XSS攻击：跨站脚本：利用浏览器的输入输出漏洞进行脚本攻击
  - 危害
    - 窃取cookie信息
    - 监听用户行为
    - 修改dom，伪造登录页面
  - 类型
    - 存储型：黑客输入脚本然后存入该站点数据库，用户访问时请求就包含了恶意脚本，执行就会被窃取用户信息
    - 反射型：该类型不需要存储在数据库，恶意链接会携带js脚本，然后在页面中执行，触发恶意操作
    - 基于DOM：通过手段修改dom，html传输中或使用中被劫持，然后修改dom
  - 防范
    - 重要数据httpOnly
    - 对页面上的输入和输出内容进行转义或过滤
    - 利用CSP（同源策略）：禁止加载或者执行其他域下的脚本
- CSRFF：跨站伪装请求：访问第三方站点时，利用用户的登录态调取接口
  - 危害
    - 窃取cookie信息
    - 伪装请求来让操作用户数据或财产
  - 类型
    - 伪造get请求（img\src等标签自动发起请求）
    - 伪造post请求（表单自动提交）
    - 吸引用户点击第三方站点链接
  - 防范
    - get 不修改数据
    - 禁止第三方网站发送cookie：设置cookit的sameSite（Strict|Lax|None）
    - CSRF Token：第一次请求下发CSRF Token、接口请求携带并校验
    - 设置白名单，不被第三方请求
    - 请求来源校验（origin、refer：安全原因有时候没有）

### 虚拟dom diff原理和实现

- 真实dom初始化为虚拟dom树
- 树的diff，深度遍历，添加索引(方便渲染差异)，同层对比 输出（diffList，diffchildren，diffprops）
  - 没有新的节点，返回
  - 有新的节点，tagname和key相同，对比属性，遍历子节点
    - 对比属性(新旧属性列表)
      - 是否有删除属性
      - 是否属性值修改
      - 是否有新加属性
    - 对比列表(新旧列表)
      - 是否有删除
      - 是否有新增
      - 是否移动
  - tagname和key不同，直接替换该节点
- 渲染差异：根据前后虚拟dom的差异节点渲染真实dom
  - 遍历patchs， 把需要更改的节点取出来
  - 局部更新dom

- js模拟dom对象的实现

```javascript
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

``` javascript
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
- 不能监听到对象新增的属性、数组push、unshift方法增加元素的变化   proxy原生全都支持

- proxy后操作的对象为，Proxy后的实例对象而不是原始对象，Proxy后的对象的this也指向新的实例代理对象

```js
let target = {
    m() {
        // 检查this的指向是不是proxyObkj
        console.log(this === proxyObj)
    }
}
let handler = {}
let proxyObj = new Proxy(target, handler)

proxyObj.m()//输出:true
target.m()//输出:false
```

- proxy缺点：由于proxy后的对象this指向也发生了改变，所以需要this来获取值的对象也不能正确代理，如下：

```js
const target = new Date();
const handler = {};
const proxyObj = new Proxy(target, handler);

proxyObj.getDate(); // TypeError: this is not a Date object.


const target = new Date('2015-01-01');
const handler = {
    get(target, prop) {
        if (prop === 'getDate') {
            // 改变this指向
            return target.getDate.bind(target);
        }
        return Reflect.get(target, prop);
    }
};
const proxy = new Proxy(target, handler);
proxy.getDate() // 1
```

### react-redux和mobx的区别

- mobx 入门更简单  redux相对较难
- mobx异步更加方便  redux需要中间件来支持
- mobx是对数据的引用 可直接修改数据的状态  redux 是immutable的思想 每次返回新的对象 需要数据流的方式去修改状态
- 正是因为这个 所以mobx更适合小项目 没有很多数据的管理 大型项目多人协作开发会容易引发冲突

### for..in和for..of的区别

- for..in：会对对象的key值进行遍历 如果是数组会遍历下标(多维数组不可遍历)  

```bash
当给数组添加属性时，也会被遍历
let arr = [1,2,3];
arr.name = 'w';
for(let i in arr){
  console.log(i)   //0,1,2,name
}
```

- for..of：会对对象的值进行遍历 还可以通过下标拿到子属性的值 只会遍历集合本身元素

### 位运算

- &位与运算

1&2 => 0001&0010 => 0
15&14 => 1111&1110 => 1110  取都等于1的公共位

- <<位左移运算
1<<2 => 0001左移两位 => 0100 => 4

### 模块化和组件化

- 模块化：是从逻辑上的划分，考虑代码的组织
- 组件化：是从UI上的划分，考虑代码的复用

### 用户体验

首先介绍一些用户体验的相关概念：

- 主动交互：需要用户去点击去触发的一些操作产生的交互  比如点击
- 被动交互：不需要用户去操作 就可以在视觉上与用户产生交互 比如 开屏广告 动画 loading
- 刷新率：屏幕每秒钟刷新的频率，这是显示设备优劣的参考值之一 值越高屏幕的流畅性越高 用户体验越好
- FPS：每秒钟往屏幕上传输的图像数量，玩游戏的朋友都应该知道这个东西，值低于60 会开始明显感觉到卡顿

体验案例:苹果的通用页面 点击会延时进入下一个页面 而不会进去后显示一个loading  尽管那个loading很短 但很影响用户的体验性

##### 如何优化长任务

因为每一秒需要至少60帧的渲染频率，每一帧也就是16.7ms，所以为了用户体验，我们应避免长任务，尤其是超过运行超过10ms的任务，因为在每一帧还需要给浏览器渲染预留时间。

但是如果是超过10ms的长任务应该怎么办呢，有两种方案，Web Worker和Time Slicing

- Web Woker：就是重启一个线程来运行长任务，而避免主线程的阻塞，而导致浏览器卡死。但缺点是无法操作dom
- Time Slicing：时间切片的概念，就是把长任务进行切割成多个执行时间很短的段任务，因为每个任务之间需要间隔，所以肯定比长任务时间长，但是基本可以做到用户无感知，例如react的Fiber调度系统，一个长任务可以被多次中断执行。

###### 去渲染数据量超大的一个列表页如何优化

- 时间切片：把一次渲染40000条数据切割成多次去渲染

```javascript
class Index extends React.Component<any,any>{
    state={
       list: []
    }
    handerClick=()=>{
       this.sliceTime(new Array(40000).fill(0), 0)
    }
    sliceTime=(list,times)=>{
        if(times === 400) return 
        setTimeout(() => {
            const newList = list.slice( times*100 , (times + 1) * 100 ) /* 每次截取 100 个 */
            this.setState({
                list: this.state.list.concat(newList)
            })
            this.sliceTime( list ,times + 1 )
        }, 0)
    }
    render(){
        const { list } = this.state
        return <div>
            <button onClick={ this.handerClick } >点击</button>
            {
                list.map((item,index)=><li className="list"  key={index} >
                    { item  + '' + index } Item
                </li>)
            }
        </div>
    }
}
```

- 虚拟列表：lib:react-tiny-virtual-list

```javascript
//只渲染当前视口范围和缓存区内的数据，列表滚动时当前让渲染区域也进行滚动，根据滚动多少计算应该展示的渲染条目
let num  = 0
class Index extends React.Component<any, any>{
    state = {
        list: new Array(9999).fill(0).map(() =>{ 
            num++
            return num
        }),
        scorllBoxHeight: 500, /* 容器高度(初始化高度) */
        renderList: [],       /* 渲染列表 */
        itemHeight: 60,       /* 每一个列表高度 */
        bufferCount: 8,       /* 缓冲个数 上下四个 */
        renderCount: 0,       /* 渲染数量 */
        start: 0,             /* 起始索引 */
        end: 0                /* 终止索引 */
    }
    listBox: any = null
    scrollBox : any = null
    scrollContent:any = null
    componentDidMount() {
        const { itemHeight, bufferCount } = this.state
        /* 计算容器高度 */
        const scorllBoxHeight = this.listBox.offsetHeight
        const renderCount = Math.ceil(scorllBoxHeight / itemHeight) + bufferCount
        const end = renderCount + 1
        this.setState({
            scorllBoxHeight,
            end,
            renderCount,
        })
    }
    /* 处理滚动效果 */
    handerScroll=()=>{
        const { scrollTop } :any =  this.scrollBox
        const { itemHeight , renderCount } = this.state
        const currentOffset = scrollTop - (scrollTop % itemHeight)
        /* translate3d 开启css cpu 加速 */
        this.scrollContent.style.transform = `translate3d(0, ${currentOffset}px, 0)`
        const start = Math.floor(scrollTop / itemHeight)
        const end = Math.floor(scrollTop / itemHeight + renderCount + 1)
        this.setState({
            start,
            end,
       })
    }
     /* 性能优化：只有在列表start 和 end 改变的时候在渲染列表 */
    shouldComponentUpdate(_nextProps, _nextState){
        const { start , end } = _nextState
        return start !== this.state.start || end !==this.state.end 
    }
    /* 处理滚动效果 */
    render() {
        console.log(1111)
        const { list, scorllBoxHeight, itemHeight ,start ,end } = this.state
        const renderList = list.slice(start,end)
        return <div className="list_box"
            ref={(node) => this.listBox = node}
        >   
            <div  
               style={{ height: scorllBoxHeight, overflow: 'scroll', position: 'relative' }}  
               ref={ (node)=> this.scrollBox = node }
               onScroll={ this.handerScroll }   
            >
                { /* 占位作用 */}
                <div style={{ height: `${list.length * itemHeight}px`, position: 'absolute', left: 0, top: 0, right: 0 }} />
                { /* 显然区 */ }
                <div ref={(node) => this.scrollContent = node} style={{ position: 'relative', left: 0, top: 0, right: 0 }} >
                    {
                        renderList.map((item, index) => (
                            <div className="list" key={index} >
                                {item + '' } Item
                            </div>
                        ))
                    }
                </div>
            </div>

        </div>
    }
}
```

##### react17

重写调度器系统，把同步长任务变成异步短任务，把渲染分布到每一帧的空隙去执行

#### instandof

```javascript
function instanceNew(obj, constructor){
  var a = obj.__proto__;
  while(a){
    if(a === constructor.prototype){
      return true
    }
    a = a.__proto__;
  }
  return false;
}
```

#### 切片上传

```javascript
const handleChange = (e) => {
  const file = e.target.files[0];
  var start=0,end=0,chunks=[],chunkSize=2*1024*1024;
  if(file.size > chunkSize) {
      while (true) {
          end+=chunkSize;
          var blob = file.slice(start,end);
          start+=chunkSize;
          
          if(!blob.size){//截取的数据为空 则结束
              //拆分结束
              break;
          }
          chunks.push(blob);//保存分段数据
      }
  }else {
      chunks.push(file)
  }
  console.log(chunks);
}
```

#### window.open

**当通过window.open打开一个窗口时，打开的窗口可以通过window.opener拿到父窗口的信息。这种可以用于子窗口在作出一些操作时，对父窗口进行一些回调操作。**

```javascript
///父窗口
window['callback'] = function() {
  console.log(111)
}
window.open('子窗口');


///子窗口
const callback = window.opener['callback']; //拿到父窗口回调方法
//do something
callback()

```

##### Objeck.key() 自动排序问题

利用 Object.keys 取得对象所有属性的 key ，然后进行 map 操作是 JavaScript 开发者常用的方法，但是如果后续逻辑依赖于map的索引值，那可能会出现问题。举例如下

```javascript
const a = { '1a': 'a', '2b': 'b', '3c': 'c' }
const arr = Object.keys(a)  // ['1a','2b','3c']

const newObj = { ...a, "11": 'd'  } // { '11': 'd', '1a': 'a', '2b': 'b', '3c': 'c' } 自动被排序
const newArr =  Object.keys(newObj)  // ['11', '1a','2b','3c']  

```

因此当对象中出纯数字或者以数字开头时，使用时可能会被排序，自动排到最前面，可能导致后续Object.keys()操作出现问题。因为不同的引擎的处理不同，所以这个问题有可能会出现。

###### 文档描述

Object.keys() 在执行过程中，若发现 key 是整数类型索引，那它首先按照从小到大排序加入；然后再按照先来先到的创建顺序加入其他元素，最后加入 Symbol 类型的 key。

###### key 何时会被识别为“整数”？

- 当key为数字开头时，也会被识别为整数，按照规则排序。
- 当纯数字<4294967295,会被识别，否则失效，按照先来先到的顺序排序

##### 总结

Object.keys() 的返回并不总能保持先来后到的顺序。从解决业务需要的角度，我们可以通过维护一个单独的 tag 数组来回避这个问题。

##### 暗黑模式

@media (prefers-color-scheme: dark) {
    html {
        filter: invert(100%) hue-rotate(180deg);
    }
}

#### 文件上传的几种方式

- action-form： form表单的方式
- formData：创建formData， 然后append上传的file
- base64：文件转换成base64 然后接口上传

#### ios上切屏或息屏倒计时停止问题

```javascript
// 定时器
const handleTimer = () => {
    if(!timer) {
        const remainSec = (info.answerDuration*60 - info.useTime + 1)*1000
        timer = setInterval(()=>{
            //第二种方案 进入页面是记录时间戳 -> 定时器每次计算当前所用时间 -> 计算出剩余时间显示出来
            let diff = moment(moment()).diff(timestamp)  
            const sec = Math.ceil((remainSec - diff)/1000)
            let str = ''
            if(sec == 600) Toast.info('考试时间还剩10分钟',1)
            if(sec <= 0) {
                clearInterval(timer)
                timer = null
                setVisible(true)
                str = zerofill(0)+':'+zerofill(0)
            }else {
                const min = Math.floor(sec/60)
                const second = Math.ceil(sec%60)
                str = zerofill(min)+':'+zerofill(second)
            }
            setTimeText(str)
        },1000)
    }else if(closeTime) {
        // 页面显示后 计算息屏时间  剩余倒计时 = 息屏前倒计时时间 - 息屏时间
        diff = diff2 - ((Date.now() - closeTime) / 1000).toFixed(0)  // 重置倒计时时间
    }
}

// 第一种方案 计算息屏时间 重置倒计时时间
useEffect(()=>{
  document.addEventListener('visibilitychange', resetTime) // 监听页面显示状态
  return ()=>{
      window.removeEventListener('visibilitychange', resetTime)
  }
},[])

const resetTime = () => {
    if (document.hidden) { //页面隐藏 记录当前时间戳和剩余倒计时时间
        diff2 = diff
        closeTime = Date.now()
    } else {
        handleTimer() //页面显示 重新倒计时
    }
}


// 进入时开始倒计时  页面摧毁后清楚定时器
useEffect(()=>{
    if(info.answerStatus === 1) {
        clearInterval(timer) 
        timer = null
        handleTimer()
    }
    return ()=>{
        console.log(4444);
        clearInterval(timer) 
        timer = null
    }
},[info])

//第三种方案  
import Countdown, { zeroPad } from 'react-countdown';
const renderer = ({ hours, minutes, seconds, completed }) => {
    if (completed) { //倒计时完成
        // do something 
    }
    if(minutes == 10 && seconds == 0) {
        // do something 
    }
    return <span>{zeroPad(hours)}:{zeroPad(minutes)}:{zeroPad(seconds)}</span>;
}
<react-countdown 
date={Date.now() + diff} //截止时间 未来的某个时间
renderer={renderer} // 自定义渲染展示的内容
/>

```

#### Generator模拟async await

都说async await是generator的语法糖实现，那到底是怎么实现的呢，我们使用generator模拟实现一个async await就知道了

```javascript
const getData = () => new Promise(resolve => setTimeout(() => resolve("data"), 1000))

async function test() {
  const data = await getData()
  console.log('data: ', data);
  const data2 = await getData()
  console.log('data2: ', data2);
  return 'success'
}

// 使用generator表示
function* testG() {
  const data = yield getData()
  console.log('data: ', data);
  const data2 = yield getData()
  console.log('data2: ', data2);
  return 'success'
}

//async执行后自动从上到下执行 而generator需要每次手动调用

//执行原理
const gen = testG();  //迭代器
const { dataPromise, isDone } = gen.next(); //执行yield getData() 返回一个promise和迭代器的结果 但并不会把值赋给data 因为现在值还是promise

dataPromise.then(val=> {
  const { dataPromise2, isDone } = gen.next(val); //把值赋给data  执行下一个yield getData()
  dataPromise2.then(val2=> {
    const { dataPromise3, isDone } = gen.next(val2);  // 同理把值赋给data2  isDone = true 迭代器执行结束
  })
})

//知道了执行原理 我们通过函数自动化的执行
function asyncToGenerator(generatorFn) {
  const gen = generatorFn.app(this) //迭代器
  return new Promise((resolve,reject)=> {
    function step(key,arg) {
      let result;
      try {
        result = step[key](arg)
      }catch(error) {
        reject(error)
      }
      const { value, isDone } = result
      if(isDone) {
        return resolve(value)
      }else {
        return Promise.resolve(value).then(val=>step('next',val), error=>reject(error)) // 迭代器未结束 继续执行
      }
    }
    step('next') //第一次执行yield
  })
}

```
