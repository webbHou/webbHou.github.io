---
title: js项目升级为ts
tags:
  - typescript
categories: js常见问题
date: 2022-11-02 18:24:36
---

### 1、下载包

```js
npm i -D typescript@babel/preset-typescript@types/react
```

### 2、修改文件

**2.1、webpack.common.js**

> 增加.ts 和.tsx

```base
resolve: {
+  extensions: [\'.js\', \'.jsx\', \'.ts\', \'.tsx\', \'.json\', \'css\'],
}
```

**2.2、删除 jsconfig.json，增加 tsconfig.json**

```json
{
  "compilerOptions": {
    "module": "ESNext",
    "target": "ES6",
    "experimentalDecorators": true,
    "noImplicitAny": false, // 支持类型不标注可以默认any
    "allowSyntheticDefaultImports": true,
    "moduleResolution": "node",
    "jsx": "react",
    "allowJs": true,
    "checkJs": false,
    "lib": ["ESNext", "DOM"],
    "strict": false,
    "baseUrl": "./",
    "paths": {
      "@/*": ["./*"],
      "@/components/*": ["./components/*"],
      "@/components": ["./components"],
      "@/js/*": ["./js/*"],
      "@/js": ["./js"],
      "@/hooks/*": ["./hooks/*"],
      "@/hooks": ["./hooks"],
      "@/src/*": ["./src/*"],
      "@/src": ["./src"]
    }
  },
  "exclude": ["node_modules", "dist"]
}
```

**2.3、babel.config.js**

> babel 预设中增加@babel/preset-typescript```base
> presets: [
> [

    "@babel/preset-env",
    {
      corejs: 3,
      modules: false,
      loose: true,
      useBuiltIns: "entry",
    }

],
"@babel/preset-react",

- "@babel/preset-typescript"
  ],

````

**2.4、eslintrc.js**

> 增加@typescript-eslint

```bash
"plugins": [
  "react",
+  "@typescript-eslint"
],
````

### 3、新增文件

**3.1、type.ts**

```js
import api from "./custom/api";
import { DZMessage as dzMessage } from "./js/utils/antd-helper";
import type { History } from "history";
import * as constValue from "./js/config/const-value";

type API = typeof api;
type DZMessage = typeof dzMessage;
type ConstValue = typeof constValue;

// 添加ts 类型，可以在使用时进行提示
type RecursiveObject<T> = T extends string ? never: T extends object? T : never;
type Result<K> = K extends string ? string : <T = any, U = any>(param?: T, options?: any) => Promise<U>
type APIValues<T, K = string> = {
    [Key in keyof T]: T[Key] extends RecursiveObject<T[Key]> ? APIValues<T[Key], number> : Result<K>;
};

declare global {
    const Invoke: APIValues<API>;
    const API: API;
    const DZMessage: DZMessage;
    const DZHistory: History;
    const ConstValue: ConstValue;
    namespace React {}
}


```

### 3.2、global.d.ts

```js
declare module \'*.css\'
declare module \'*.scss\'
declare module \'*.less\'
declare module \'*.json\'
declare module \'*.jpg\'
declare module \'*.jpge\'
declare module \'*.png\'
declare module \'*.gif\'
declare module \'*.svg\'
declare module \'*.bmp\'

```
