---
title: immutable使用详解
tags:
  - javascript
categories: js常见问题
date: 2019-01-16 14:26:13
---

###什么是immutable Data

immutable Data就是一旦创建就不可变的数据，每次的修改和添加删除操作都会返回新的immutable Data数据，Immutable 实现的原理是 Persistent Data Structure（持久化数据结构），immutable会共享相同的数据结构，当修改时只会对有影响的节点进行修改，其余的继续共享，避免了deepclone把所以节点都复制一遍带来的性能损耗，immutable解决了复杂类型引用赋值带来的数据隐患。


###immutable的优点

- 降低了复杂可变数据带来的复杂度
- 节省内存(共享相同的节点)
- 函数式编程


###常用的immutable数据结构

- Map：键值对集合，对应于 Object，ES6 也有专门的 Map 对象
- List：有序可重复的列表，对应于 Array
- Set：无序且不可重复的列表

###常见用法
- Immutable.is(比较两个immutable对象的值 ===比较内存)
- Immutable.fromJS([1,2]) 生成不可变对象(支持数据嵌套)
- Immutable.List([1,2]}) 生成不可变对象(不支持数据嵌套)
- immutableData.toJS() 不可变数据生成 JavaScript 对象
- immutableA is immutableB 判断两个数据引用是否一致

###List常用方法
- Immutable.List([1,2]) 生成不可变List 数据
- immutableA.size/immutableA.count() 查看List 大小
- Immutable.List.isList(x) 判断是不是List
- immutableData.get(0)/immutableData.set(0,el) 根据索引读写对象
- immutableData.getIn [1, 2]/immutableData.setIn [1, 2]  读写嵌套数组中的数据
- immutableB.update(1,(x) -> x + 1)/immutableB.updateIn [2, 1], (x) -> x + 1 更新不可变数据  接受函数
- immutableData.find (x)=>x>1 查找
- immutableData.filter (x) ->x>1 过滤
- immutableData.filterNot (x) -> x <= 1  取反过滤
- immutableData.sort (a, b) -> return a>b?-1:1 排序
- immutableData.forEach (a, b)=> 遍历

###Map常用方法
- Immutable.Map.isMap(x) 判断是不是map
- immutableData.get('a')/immutableData.getIn(['a','b']) 直接/嵌套更新获取
- immutableA.set('a', 1)/immutableA.setIn( ['a', 'b'], 1) 直接/嵌套更新设置
- immutableA.update ('a', (x) -> x + 1)/immutableA.updateIn (['a', 'b'], (x) -> x + 1)  直接/嵌套更新数据
- immutableA.merge(immutableC)  合并对象
- immutableData.has('key')  判断是否存在该属性
- data.filter (value, key) -> value is 1  属性过滤


