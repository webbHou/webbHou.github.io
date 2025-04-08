---
title: visibleHoc高阶组件开发及使用
tags:
  - javascript
categories: js常见问题
date: 2022-11-02 18:12:37
---


## 正常Modal的使用示例

### 定义一个普通Modal

```
const ModalNormal = (props) => {

    // 关闭Modal
    const hideModal = () => {
        props.switchVisible(false)
    }

    return (
        <Modal
            title="普通弹出Modal"
            visible={props.visible}
           >
            普通弹出Modal
        </Modal>
    )
}

export default ModalNormal
```

### 使用普通Modal
```
const DemoModal = () => {

    // 定义显示的状态
    const [isVisibleModal, set_isVisibleModal] = useState(false)

    // 切换显示状态
    const switchNormalModalVisible = (visible = false) => {
        set_isVisibleModal(visible)
    }

    // 点击，切换状态，弹出Modal
    const onClick_modalNormal = () => {
        switchNormalModalVisible(true)
    }

    return (
        <div>
            <Button onClick={onClick_modalNormal}>弹出普通Modal</Button>

            <ModalNormal
                visible={isVisibleModal}
                switchVisible={switchNormalModalVisible}
            />
        </div>
    )
}

export default DemoModal
```

## 使用VisibleHOC后，Modal的使用示例
### 定义一个VisibleHOC包装的Modal
```
import VisibleHOC from "@/components/visible-hoc/index.js";
const ModalHOC = (props) => {
    return (
        <Modal
            title="VisibleHOC 弹出Modal"
            // props.visible 是 VisibleHOC 注入的
            visible={props.visible}
            // props.onCloseIt 方法，是 VisibleHOC 注入的
            onCancel={props.onCloseIt}
            onOk={props.onCloseIt}
        >
            VisibleHOC 弹出Modal
        </Modal>
    )
}

// 使用VisibleHOC包装一下
export default VisibleHOC(ModalHOC)
```
### 使用VisibleHOC包装的Modal
```html
const DemoModal = () => {

    // 点击，调用openIt，弹出Modal
    const onClick_modalHOC = () => {
        // 传递的值，可以在Modal里，使用props.options获取
        ModalHOC.openIt({ a: 1, b: 2 })
    }

    return (
        <div>
            <Button onClick={onClick_modalHOC}>使用HOC弹出Modal</Button>

            <ModalHOC />
        </div>
    )
}

export default DemoModal
```

## 对比可见
> 代码量，减少很多。避免重复定义状态，切换状态的方法

> 父组件弹出、Modal组件内部关闭，变得非常简单

## VisibleHOC使用说明

> 包裹后，返回的组件

名称|说明|类型
--|--|--
openIt|打开。支持传参，组件内部使用props.options获取|方法
closeIt|关闭|方法
visible|获取组件状态|属性，布尔值

> 被包裹的组件

名称|说明|类型
--|--|--
onOpenIt|打开|方法
onCloseIt|关闭|方法
visible|可见状态|属性，布尔值
options|closeIt传递进来的值|属性，对象

## 注意事项
> 包裹返回的组件，使用的是**openIt、closeIt**。被包裹的组件，使用**onOpenIt、onCloseIt**。方法名是不同的，用来区分是外部调用（方法），还是内部调用（事件）

> 被包裹的组件，也可以和正常Modal一样的使用，手动传入visible，来控制显示和关闭。手动传入自定义属性


### 组件源码

```javascript
import React from "react"
import { PackageEnv } from "@/js/utils/base.js"

const GlobalConfig = {
    store: {},
    get(id, instance) {
        if (PackageEnv.isDev) {
            return this.store[id]
        }

        return instance
    },
    set(id, instance) {
        if (PackageEnv.isDev) {
            this.store[id] = instance
        }
    },
}

const VisibleHOC = function (Component, id) {
    // console.warn(1, "VisibleHOC", Component.name, id)

    let curId = id || Component.name

    let instance = null

    const switchVisible = function (visible = false, options) {
        let state = { visible }
        if (options !== undefined) {
            state.options = options;
        }

        let curInstance = GlobalConfig.get(curId, instance)
        // console.log('switchVisible', curInstance, state)
        curInstance && curInstance.setState(state)
    }

    const open = function (opts) {
        switchVisible(true, opts)
    }

    const close = function () {
        switchVisible(false)
    }

    const checkVisible = function () {
        let curInstance = GlobalConfig.get(curId, instance)
        return curInstance ? curInstance.state.visible : false
    }

    return class extends React.PureComponent {
        constructor(props) {
            super(props)
            instance = this

            GlobalConfig.set(curId, this)
        }

        static openIt = open
        static closeIt = close
        static get visible() {
            return checkVisible()
        }

        state = {
            visible: false,
            options: null,
        }

        componentDidMount() {
            instance = this

            GlobalConfig.set(curId, this)
        }

        componentWillUnmount() {
            instance = null

            GlobalConfig.set(curId, null)
        }

        render() {
            return (
                <Component
                    visible={this.state.visible}
                    options={this.state.options}
                    onOpenIt={open}
                    onCloseIt={close}
                    {...this.props}
                />
            )
        }
    }

}

export default VisibleHOC;

```