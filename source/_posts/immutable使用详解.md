---
title: immutable使用详解
tags:
  - javascript
  - immutable
categories: 学习
date: 2019-01-16 14:26:13
---

### 什么是immutable Data

immutable Data就是一旦创建就不可变的数据，每次的修改和添加删除操作都会返回新的immutable Data数据，Immutable 实现的原理是 Persistent Data Structure（持久化数据结构），immutable会共享相同的数据结构，当两个对象的hashCode相同，值就相同。当修改时只会对有影响的节点进行修改，其余的继续共享，避免了deepclone把所以节点都复制一遍带来的性能损耗，immutable解决了复杂类型引用赋值带来的数据隐患。

### immutable的优点

- 降低了复杂可变数据带来的复杂度
- 节省内存(共享相同的节点)
- 函数式编程

### 常用的immutable数据结构

- Map：键值对集合，对应于 Object，ES6 也有专门的 Map 对象
- List：有序可重复的列表，对应于 Array
- Set：无序且不可重复的列表

### 常见用法

- immutableA.immutableB(bb) A融合B
- Immutable.Map({1:2}) 创建一个Map
- Immutable.is(比较两个immutable对象的值 ===比较内存)
- Immutable.fromJS([1,2]) 生成不可变对象(支持数据嵌套)
- Immutable.List([1,2]}) 生成不可变对象(不支持数据嵌套)
- immutableData.toJS() 不可变数据生成 JavaScript 对象
- immutableA is immutableB 判断两个数据引用是否一致
- Immutable.toObject 转化为对象
- Immutable.toArray 转化为数组

### List常用方法

- Immutable.List.of([1,3]) 创建一个List
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

### Map常用方法

- Immutable.Map.isMap(x) 判断是不是map
- immutableData.get('a')/immutableData.getIn(['a','b']) 直接/嵌套更新获取
- immutableA.set('a', 1)/immutableA.setIn( ['a', 'b'], 1) 直接/嵌套更新设置
- immutableA.update ('a', (x) -> x + 1)/immutableA.updateIn (['a', 'b'], (x) -> x + 1)  直接/嵌套更新数据
- immutableA.merge(immutableC)  合并对象
- immutableData.has('key')  判断是否存在该属性
- immutableData.filter (value, key) -> value is 1  属性过滤
- immutableData.map(v=>v*V)

### Immutable与react搭配使用

React性能优化的重要步骤就是避免重复渲染，使用的react生命周期函数shouldComponentUpdate进行新旧节点的比较，来判断是否需要更新，来减少一些不必要的渲染。

利用immutable的is和===进行比较，简单且高效，极大的提高了性能。而不像deepclone对性能的极大损耗

```bash
import { is } from 'immutable';

shouldComponentUpdate: (nextProps = {}, nextState = {}) => {
  const thisProps = this.props || {}, thisState = this.state || {};

  if (Object.keys(thisProps).length !== Object.keys(nextProps).length ||
      Object.keys(thisState).length !== Object.keys(nextState).length) {
    return true;
  }

  for (const key in nextProps) {
    if (thisProps[key] !== nextProps[key] || ！is(thisProps[key], nextProps[key])) {
      return true;
    }
  }

  for (const key in nextState) {
    if (thisState[key] !== nextState[key] || ！is(thisState[key], nextState[key])) {
      return true;
    }
  }
  return false;
}
```

### Immutable与state的搭配使用

其实在React官方是建议把this.state当作Immutable当作，所以如果用deepclone会非常耗性能

```bash
initData = {
  data: Map({ times: 0 })
}
this.setState({ data: this.state.data.update('times', v => v + 1) }); //更优 this.setState( ({data})=> ({ data: data.update('times', v => v + 1) }) );
```

### Immutable与redux的集成

redux是目前流行的共享数据状态管理库，它提供更简洁和清晰的单向数据流（View -> Action -> Middleware -> Reducer->store）来进行共享的改变
为了state和store数据的统一而不至于混乱难以维护，除了向服务器交互发送的数据其余都建议使用Immutable数据，而在请求数据后需要转化为Immutable数据

reducers 我们用 redux-immutable 提供的 combineReducers 来处理，他可以将 immutable 类型的全局 state 进行分而治之。
redux-immutable也会帮助你在 store 初始化的时候，通过每个子 reducer 的初始值来构建一个全局 Map 作为全局 state。当然，这要求你的每个子 reducer 的默认初始值是 immutable的。
