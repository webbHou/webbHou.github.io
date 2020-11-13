---
title: readux异步操作及react-thunk中间件原理解析
tags:
  - javascript
categories: js常见问题
date: 2020-10-19 18:55:11
---

##### redux的异步操作是怎么进行的

用过redux的应该都知道，redux的工作流是同步的过程，用户在页面触发动作dispatch一个action，然后被分配到对应的reducer，然后根据action的type进行同步的处理，然后更新store，subscribe监控store的改变对页面的state进行更新。

action必须要由dispatch去发起，还有action必须返回object，所以如果一个异步操作需要进行，有下面两种方式：

- 闭包：改写dispatch可以接受一个函数，函数执行返回一个异步函数，在异步完成后进行dispatch的调用。但是dispatch不是全局变量，所以需要进行保存，所以用闭包的方式进行保存，来保证异步完成后可以去dispatch，这就是Redux-thunk的做法。
- 监听action：一般的流程是dispatch后的action会进入reducer，但是reducer是同步操作，所以我们需要去监听这个action异步处理后再发起真正的action，redux-saga就是这样的原理。

##### 为什么要使用chunk

上边说过我们可以在异步完成后去disptach一个action，所以我们可以这样

```javascript
setTimeout(()=>{
  this.props.dispatch(action)
},2000)
```

但是当我们需要大量的重复操作，我们需要给每一个发出异步的组件都必须注入dispatch，还需要去区分同步还是异步的操作。还有的甚至还需要逻辑操作，需要获取state。这样以后就变得很难维护。所以在thunk中我们直接将dispatch和getState注入到返回的函数参数中，直接可以使用。

##### redux-thunk原理

上边说到通过改造dispatch方法接受一个函数，然后运用闭包的方式在函数执行结束后去dispatch一个action。

###### 用法

```javascript
const store = createStore(
  reducer,
  applyMiddleware(thunk),
);

function increment() {
  return {
    type: 'INCREMENT'
  }
};
function incrementAsync() {
  return (dispatch,getState) => {
    setTimeout(() => {
      dispatch(increment()); //异步操作
    }, 1000);
  }
}
 store.dispatch(incrementAsync);
```

###### 原理

```javascript
function thunk(store) {  //一个中间件首先接受一个store
  return function(next) {  //然后接受一个next 类似express的中间件 洋葱模型
    return function(action) { //真正的action
      const { dispatch, getState } = store;
      if (typeof action === 'function') {  //如果是函数则先去执行  再去发起真正的action
        return action(dispatch, getState);
      }
      let result = next(action); //普通action会进入next 按洋葱模型的方式 去到下一个中间件被处理 最后被返回
      return result
    }
  }
}
```

###### 额外的参数

```javascript
const store = createStore(
  reducer,
  applyMiddleware(thunk.withExtraArgument({ api, whatever })),
);

function fetchUser(id) {
  return (dispatch, getState, { api, whatever }) => {
    // 现在你可以使用这个额外的参数api和whatever了
  };
}
```

所以我们需要给thunk一个额外的方法去接受参数

```javascript
function createThunkMiddleware(extraArgument){
  return function thunk(store) {  //一个中间件首先接受一个store
    return function(next) {  //然后接受一个next 类似express的中间件 洋葱模型
      return function(action) { //真正的action
        const { dispatch, getState } = store;
        if (typeof action === 'function') {  //如果是函数则先去执行  再去发起真正的action
          return action(dispatch, getState, extraArgument);
        }
        let result = next(action); //普通action会进入next 按洋葱模型的方式 去到下一个中间件被处理 最后被返回
        return result
      }
    }
  }
}
const thunk = createThunkMiddleware();
thunk.withExtraArgument = createThunkMiddleware;
```

最后放出官方源码

```javascript
function createThunkMiddleware(extraArgument) {
  return ({ dispatch, getState }) => (next) => (action) => {
    if (typeof action === 'function') {
      return action(dispatch, getState, extraArgument);
    }

    return next(action);
  };
}

const thunk = createThunkMiddleware();
thunk.withExtraArgument = createThunkMiddleware;

export default thunk;
```
