---
title: 面试秘籍-htmlcss篇
tags:
  - javascript
categories: 面试
date: 2019-02-18 14:53:53
---

### 盒模型

页面渲染时，dom 元素所采用的 布局模型。可通过box-sizing进行设置。根据计算宽高的区域可分为：

- content-box(w3c标准模型)：元素实际宽=width
- border-box(怪异盒模型)：元素实际宽=width-padding-border
- margin-box


### BFC

块级格式化上下文，一个独立的块渲染区域，让处于 BFC 内部的元素与外部的元素相互隔离，使内外元素的定位不会相互影响。

bfc的形成条件(满足其一)：
- 根元素
- float不等于none
- position：absolute/fixed
- display：inline-block/table-cell
- overflow不等于visible

bfc的约束条件：
- 属于同一个 BFC 的两个相邻 Box 垂直排列
- 属于同一个 BFC 的两个相邻 Box 的 margin 会发生重叠
- BFC 中子元素不会超出他的包含块
- BFC 的区域不会与 float 的元素区域重叠
- 计算 BFC 的高度时，浮动子元素也参与计算
- 文字层不会被浮动层覆盖，环绕于周围

bfc应用：
- 阻止margin重叠
- 清除浮动(解决高度塌陷)
- 阻止与浮动元素重叠
- 自适应三栏布局

###居中布局

水平居中布局
- 行内元素: text-align: center
- 块级元素: margin: 0 auto
- absolute + transform
- flex + justify-content: center

垂直居中布局
- line-height: height
- absolute + transform
- flex + align-items: center
- table

水平垂直居中
- absolute + transform
- flex + justify-content: center + align-items: center

###选择器优先级
!important > 行内样式 > #id > .class > tag > * > 继承 > 默认

###去浮动
- 通过增加伪元素清除浮动
- 创建父级BFC区域
- 父级设置高度

###link和import区别
- link可以用于加载rel、css等 import只能加载css
- link加载的css会在编译时同步加载并执行 impirt引入的会在页面加载完成后加载
- @import需要 IE5 以上才能使用
- link可以使用 js 动态引入，@import不行

###CSS预处理器(Sass/Less/Postcss)

CSS预处理器的原理: 是将类 CSS 语言通过 Webpack 编译 转成浏览器可读的真正 CSS。在这层编译之上，便可以赋予 CSS 更多更强大的功能，常用功能:
- 嵌套
- 变量
- 循环语句
- 条件语句
- 自动前缀
- 单位转换
- mixin复用

###CSS动画

####过渡动画translation

- transition-property: 属性
- transition-duration: 间隔
- transition-timing-function: 曲线
- transition-delay: 延迟
- 常用钩子: transitionend(过渡完成事件)

####animation / keyframes
- animation-name: 动画名称，对应@keyframes
- animation-duration: 间隔
- animation-timing-function: 曲线
- animation-delay: 延迟
- animation-iteration-count: 次数 （infinite: 无限循环动画）
- animation-direction: 方向 （alternate: 反向播放）
- animation-fill-mode: 静止模式 （forwards: 停止时，保留最后一帧 backwards: 停止时，回到第一帧 both: 同时运用 forwards / backwards）
- 常用钩子: (animationend动画完成事件)

###创建一个对象的步骤：
1.新建一个对象
2.把构造函数的this指向这个对象
3.执行构造函数
4.返回这个对象


### flex-grow和flex-shrink有什么用

* flex-grow：当元素设置该属性时，当父元素还有剩余空间时会按flex-grow的值比例分给该元素 子元素的flex-grow值总和小于1时 **分配空间是剩余空间*flex-grow值总和**
* flex-shrink：当元素设置该属性时，当子元素的空间总和大于父元素时，会按flex-grow的值比例收缩，子元素的flex-grow值总和小于1时 **收缩空间是超出空间*flex-grow值总和**


### 三栏布局

- float：
  .left: float:left; width: 300px
  .right: float:right; width: 300px
  .center: margin: 0 300px

- absolute:
  .left: position: absolute; left:0; width: 300px
  .right: position: absolute; right:0; width: 300px
  .center: margin: 0 300px

- flex:
  .main: display:flex
  .left: width: 300px
  .right: width: 300px

- table:
  .main: display:table
  .left: display:table-cell; width: 300px
  .right: display:table-cell; width: 300px
  .center: display:table-cell;

- grid:
  .main: display:grid; grid-template-rows: 100px; grid-template-columns: 300px auto 300px;