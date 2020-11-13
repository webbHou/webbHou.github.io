---
title: flutter学习及实践
tags:
  - javascript
  - flutter
categories: 学习
date: 2020-07-13 14:50:47
---

### 数据结构

String、Number、Null、Map、List、Symble、弱类型(var、object、dynamic)

#### 运算符

- ??：0??1相当于0?0:1
- 联级操作：允许一个对象或函数进行一系列操作，比如一个对象有多个方法可以进行依次调用

#### 类和构造函数

- 构造函数：一个类可以有多个构造函数，在实例化时可以选择调用
- 抽象类：关键字abstract声明，实现一个类被用于其他子类继承，抽象类是无法实例化的
- 泛型类：不确定返回数据结构时使用，class Array<T>

#### 访问控制

- public(默认)
- 私有：则在方法或者属性名前使用“_”

#### 库调用

import 'package:startup_namer/pages/homepage.dart';

import 为关键词，package 为协议，可以使用 http 的方式，不过最好使用本地 package 方式。

#### 运行机制

先微任务再事件任务，dart线程不共享变量，线程间通过消息机制传递信息。

#### 多线程

isolate
