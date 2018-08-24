---
title: mvvm框架原理
tags:
  - javascript
  - mvvm
  - 框架
categories: js常见问题
date: 2018-03-06 17:35:45
---

最近几年前端技术层出不穷，行业生态和技术创新形式一片大好，涌现出了一大批框架、ui库、构建工具等，前端变得越来越不可替代，在公司的地位也越来越重要，工作内容页越来越有趣和技术性。当然也有坏的一面，层出不穷的技术当然会让很大一批人迷茫和不知从何学起，但随之慢慢的沉淀，更好的技术慢慢的被大家所接受和运用，react、vue等mvvm现在已经成为了一个前端er必须了解的东西，以下将从原理上对mvvm框架进行解析。

### 什么是mvvm

m即modle模型逻辑层，v即view视图层。mvvm体现了这个框架的运行原理，也就是模型驱动视图，视图的改变更改模型。也就是双向数据绑定的核心。

### 双向数据绑定的原理

vue主要运用了原生得Object.defindproperty()方法进行data数据的getter和setter,然后追踪依赖,当数据发生改变时,发布通知给订阅者,然后通过computed进行计算后,生成新的虚拟dom，然后通过diff算法进行新老视图的对比，然后进行视图的更新。

```bash
<script>
    function Vue(opts){
        this.data =opts.data;
        this.el =opts.el;
        var data = this.data;
        var me = this;
        var el = document.querySelector(this.el);
        observer(data,this);      
        var dom =  nodeToFragment(el,this);
        el.appendChild(dom);
    }
    function nodeToFragment(node,vm){
        var frag = document.createDocumentFragment();
        var child;
        while(child = node.firstChild){
            complie(child,vm);
            frag.append(child);
        }
        return frag;
    }
    function complie(node,vm){
        var reg = /\{\{(.*)\}\}/;
        if(node.nodeType == 1){
            var attrs = node.attributes;
            for(var i = 0,len = attrs.length;i < len;i++){
                if(attrs[i].nodeName == 'v-model'){
                    var name =attrs[i].nodeValue;
                    node.addEventListener('input',function(e){
                        vm[name] = e.target.value;
                    })
                    node.value = vm[name];
                    node.removeAttribute('v-model');
                }
            }
            new watch(vm,node,name,'input')
        }
        if(node.nodeType ==3){
            if(reg.test(node.nodeValue)){
                var name = RegExp.$1;
                name = name.trim();
                nodeType = 'text';
                new watch(vm,node,name,'text')
            }         
        }
    }
    function watch(vm,node,name,nodeType){
        Dep.target = this;
        this.name = name;
        this.node = node;
        this.vm = vm;
        this.nodeType = nodeType;
        this.update();
        Dep.target = null;
    }
    watch.prototype = {
        update:function(){
            this.get();
            if(this.nodeType == 'text'){
                this.node.nodeValue = this.value;
            }
            if(this.nodeType == 'input'){
                this.node.value = this.value;
            }
        },
        get:function(){
            this.value = this.vm[this.name];
        }
    }
    //observer
    function observer(data,vm){
        Object.keys(data).forEach(function(key){
            defineReactive(vm,key,data[key]);
        })
    }
    function defineReactive(vm,key,val){
        var dep = new Dep();
        Object.defineProperty(vm,key,{
            get:function(){
                if(Dep.target){
                    dep.addSub(Dep.target);
                }
                return val;
            },
            set:function(newVal){
                if(newVal == val) return;
                val = newVal;
                dep.notify();
            }
        })
    }
    function Dep(){
        this.subs = [];
    }
    Dep.prototype = {
        addSub:function(sub){
            this.subs.push(sub);
        },
        notify:function(){
            this.subs.forEach(function(sub){
                sub.update();
            })
        }
    }
    var vm = new Vue({
        el:'#app',
        data:{
            'msg':'hello duanduan'
        }
    });
</script>
```

### diff算法

diff 的实现主要通过两个方法，patchVnode 与 updateChildren 。
patchVnode 有两个参数，分别是老节点 oldVnode, 新节点 vnode 。主要分五种情况：

if (oldVnode === vnode)，他们的引用一致，可以认为没有变化。
if(oldVnode.text !== null && vnode.text !== null && oldVnode.text !== vnode.text)，文本节点的比较，需要修改，则会调用Node.textContent = vnode.text。
if( oldCh && ch && oldCh !== ch ), 两个节点都有子节点，而且它们不一样，这样我们会调用 updateChildren 函数比较子节点，这是diff的核心，后边会讲到。
if (ch)，只有新的节点有子节点，调用createEle(vnode)，vnode.el已经引用了老的dom节点，createEle函数会在老dom节点上添加子节点。
if (oldCh)，新节点没有子节点，老节点有子节点，直接删除老节点。



