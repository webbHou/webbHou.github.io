---
title: hooks的使用和如何定义hooks
tags:
  - javascript
categories: js常见问题
date: 2020-11-17 14:24:34
---

#### 常用的一些hooks

- useState：类似class组件的state 用来定义一些状态和变量
- useEffect：副作用操作 可以在依赖值改变时执行一些副作用操作 可以用来模拟一些生命周期操作
- useRef：用来定义一个ref
- useContext：接收一个context 并返回最新的context值 当该组件依赖的Provider.context更新时   该hooks会触发重新渲染
- useReducer: 接受一个reducer和默认state值 返回最新的state和dispatch函数
- useMemo：返回一个值，当依赖项改变时重新计算
- useCallback：接受一个回调函数和依赖数组，返回一个回调函数，该函数可以在依赖项改变时更新 回调会手动调用  普通函数不会更新

```javascript
const ThemeContext = React.createContext(themes.light);

function App() {
  return (
    <ThemeContext.Provider value={themes.dark}>
      <Toolbar />
    </ThemeContext.Provider>
  );
}
function Toolbar(props) {
  return (
    <div>
      <ThemedButton />
    </div>
  );
}

function ThemedButton() {
  const theme = useContext(ThemeContext);
  return (
    <button style={{ background: theme.background, color: theme.foreground }}>
      I am styled by theme context!
    </button>
  );
}
```

#### 如何自定义一个hooks

```javascript
//监听网络状态和类型的hooks  
//可以在网络连接变化和类型变化是进行不同的展示和提示 提高用户体验
export function useNetChange () {
  const [isConnected, setIsConnected] = useState(true); //网络是否连接
  const [networkType, setNetworkType] = useState(true); //网络类型
  let initStatus = true;

  useEffect(()=>{  //第一次进来获取网络状态和类型
    Taro.getNetworkType().then(res=>{
      if(res.networkType === 'none'){
        setIsConnected(false)
        initStatus = false;
      }
      setNetworkType(res.networkType)
    })
  }, [])

  const cancleNetChange = () => { //取消网络变化监听  应用该hooks的组件每次更新后清除 effect 避免执行多次监听函数 导致内存泄漏
    Taro.offNetworkStatusChange();
  }

  Taro.onNetworkStatusChange(function (res) { //监听网络变化
    setIsConnected(res.isConnected);
    setNetworkType(res.networkType);
  })
  return [isConnected, initStatus, networkType, cancleNetChange]
}
```
