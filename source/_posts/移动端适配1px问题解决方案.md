---
title: 移动端适配1px问题解决方案
tags:
  - 移动端
  - 适配
categories: 移动端
date: 2018-03-06 16:33:46
---

在之前的一个项目中,在测试后发现,在Retina屏幕下边框变宽了,经过我自己检查修改,发现确实存在这个问题,一下对这个问题进行剖析和解决方案的总结:

### 边框变粗的原因

其实这个问题是因为不同手机的分辨率不同造成的,也就是设备物理像素和逻辑像素的不同造成的,物理像素也就是也就是设备的分辨率,逻辑像素就是设备的尺寸像素。在window对象下有一个deviceRatio的属性,这个值就是物理像素和逻辑像素的比值。当这个值大于1时就成为Retina屏。css中的1px在设备中显示时就会等比例的加粗。

>devicePixelRatio的官方的定义为：设备物理像素和设备独立像素的比例，也就是 devicePixelRatio = 物理像素 / 独立像素。


### 解决边框变粗的7种办法

1、0.5px边框: 解决方案是通过 JavaScript 检测浏览器能否处理0.5px的边框，如果可以，给html标签元素添加个class。

```bash
if (window.devicePixelRatio && devicePixelRatio >= 2) {
  var testElem = document.createElement('div');
  testElem.style.border = '.5px solid transparent';
  document.body.appendChild(testElem);
}
if (testElem.offsetHeight == 1) {
  document.querySelector('html').classList.add('hairlines');
}
  document.body.removeChild(testElem);
}
// 脚本应该放在内，如果在里面运行，需要包装 $(document).ready(function() {})
```
样式代码:

```bash
div {
  border: 1px solid #bbb;
}
.hairlines div {
  border-width: 0.5px;
}
```

优点: 代码简单  缺点: 无法兼容安卓设备、 iOS 8 以下设备。

2.使用border-image实现

样式设置
```bash
.border-bottom-1px {
  border-width: 0 0 1px 0;
  -webkit-border-image: url(linenew.png) 0 0 2 0 stretch;
  border-image: url(linenew.png) 0 0 2 0 stretch;
} 
```

但是会在非Retina屏下不显示的情况,做了以下潘丹处理:
```bash
.border-image-1px {
  border-bottom: 1px solid #666;
}
@media only screen and (-webkit-min-device-pixel-ratio: 2) {
  .border-image-1px {
    border-bottom: none;
    border-width: 0 0 1px 0;
    -webkit-border-image: url(../img/linenew.png) 0 0 2 0 stretch;
    border-image: url(../img/linenew.png) 0 0 2 0 stretch;
  }
}
```
优点：
可以设置单条,多条边框
没有性能瓶颈的问题

缺点：
修改颜色麻烦, 需要替换图片
圆角需要特殊处理，并且边缘会模糊

3.使用background-image实现

和border-image的原理相同

4.多背景渐变

与background-image方案类似，只是将图片替换为css3渐变。设置1px的渐变背景，50%有颜色，50%透明。

```bash
.background-gradient-1px {
  background:
    linear-gradient(#000, #000 100%, transparent 100%) left / 1px 100% no-repeat,
    linear-gradient(#000, #000 100%, transparent 100%) right / 1px 100% no-repeat,
    linear-gradient(#000,#000 100%, transparent 100%) top / 100% 1px no-repeat,
    linear-gradient(#000,#000 100%, transparent 100%) bottom / 100% 1px no-repeat
}
/* 或者 */
.background-gradient-1px{
  background:
    -webkit-gradient(linear, left top, right bottom, color-stop(0, transparent), color-stop(0, #000), to(#000)) left / 1px 100% no-repeat,
    -webkit-gradient(linear, left top, right bottom, color-stop(0, transparent), color-stop(0, #000), to(#000)) right / 1px 100% no-repeat,
    -webkit-gradient(linear, left top, right bottom, color-stop(0, transparent), color-stop(0, #000), to(#000)) top / 100% 1px no-repeat,
    -webkit-gradient(linear, left top, right bottom, color-stop(0, transparent), color-stop(0, #000), to(#000)) bottom / 100% 1px no-repeat
}
```
优点：
可以实现单条、多条边框
边框的颜色随意设置

缺点：
代码量不少
圆角没法实现
多背景图片有兼容性问题

5.使用box-shadow模拟边框

```bash
.box-shadow-1px {
  box-shadow: inset 0px -1px 1px -1px #c8c7cc;
}
```
优点：代码量少可以满足所有场景
缺点：边框有阴影，颜色变浅

6.viewport + rem 实现

通过js获取设备的devicePixelRatio值，来设置对应viewport属性值，然后设置不同的rem转化比例，这种方式就可以像以前一样轻松愉快的写1px了。

这种兼容方案相对比较完美，适合新的项目，老的项目修改成本过大。可以看下[淘宝的flexible适配方案](https://github.com/amfe/article/issues/17)。


7.伪类 + transform 实现

老项目可以使用这个方案

```bash
.scale-1px{
  position: relative;
  border:none;
}
.scale-1px:after{
  content: '';
  position: absolute;
  bottom: 0;
  background: #000;
  width: 100%;
  height: 1px;
  -webkit-transform: scaleY(0.5);
  transform: scaleY(0.5);
  -webkit-transform-origin: 0 0;
  transform-origin: 0 0;
}
```