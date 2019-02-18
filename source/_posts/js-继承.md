---
title: js 继承
tags:
  - javascript
categories: js常见问题
date: 2019-01-14 11:32:16
---


function Anmial(){
  this.special = '动物';
}

function Cat(){
  this.name = '猫';
}

1.执行继承对象的构造函数
function Cat(name){
  Anmial.apply(this,arguments);
  this.name = '猫';
}

2.原型指向
Cat.prototype = new Anmial(); //对象的prototype指向原型的实例

Cat.prototype.constructor = Cat;  //对象的protype的constructor属性指向自己



