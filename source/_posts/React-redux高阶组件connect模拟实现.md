---
title: React-redux高阶组件connect模拟实现
tags:
  - javascript
categories: js常见问题
date: 2019-06-22 13:55:29
---


 ```bash
/**
 * 模拟connect
 */

import React,{ Component } from 'react';

import { PropTypes } from 'prop-types';


const connect = (mapStateToProps,mapDispatchToprops) => (Wrapcompont) =>{
    return class extends Component{
        state={
            allprops:{}
        }
        static contextTypes = {
            store: PropTypes.object
        }

        componentDidMount(){
            const store = this.context.store;
            console.log(this.context)
            this._update();
            store.subscribe(() => this._update());
        }

        //数据更新页面更新
        _update(){
            const store = this.context.store;
            const state = mapStateToProps?mapStateToProps(store.getState()):{};
            const dispatch = mapDispatchToprops?mapDispatchToprops(store.dispatch):{};
            this.setState({
                allprops:{...state,...dispatch,...this.props}
            })
        }

        render(){
            return <Wrapcompont {...this.state.allprops} />
        }
    }
}

export default connect
 ```