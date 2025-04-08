---
title: Rust入门和实践
tags:
    - Rust
categories: js常见问题
date: 2022-03-03 17:16:51
---

#### 什么是 Rust

rust 是一个静态的编译型语言，在语法，机制上都跟 C/C++很像，**特点就是快，因此非常适合做计算密集型的东西**

目前很多前端工程化工具如 webpack、babel 都是使用 js 来实现的，但 JS 这种动态的解释性+单线程语言，在性能上是天然不足的，有局限性。

所以现在很多工具从底层实现来解决这一问题，比如 esbuild 才有 go 语言。根据 Rust 的特点，在前端工程化领域现在越来越被需要。

另外 webassembly 对 rust 支持友好，在一些计算密集型的项目中，比如在线文档，云 IDE，可视化领域都非常有潜力。所以在前端生态进步的未来，有可能大有作为。

#### swc

swc 是目前第一个使用 rust 语言实现的编译工具，用来替代 babel，其编译的速度比 babel 快了 10 倍不止。

#### Rust 入门

##### Cargo 命令

cargo: 类似于 node 的 npm，是 rust 的包管理工具 常用命令：

-   cargo add 添加依赖
-   cargo new 新建项目
-   cargo build 可以构建项目 --release 来优化编译项目
-   cargo run 可以运行项目
-   cargo test 可以测试项目
-   cargo doc 可以为项目构建文档
-   cargo publish 可以将库发布到 crates.io。
-   cargo check 快速检查代码确保其可编译

##### 目录文件

-   main.rs 入口文件
-   rustc -> node 可执行.rs 文件
-   rustup -> nvm 版本管理
-   cargo -> npm 包管理
-   cargo.toml -> package.json 包信息管理
-   target -> dist 打包后目录

##### 常用语法和概念

变量和可变性：

```rust
let x = 5;  // 一旦创建不可修改 可避免不可知错误
let mut x = 5; // 变量名前加mut使可变  也告知了后续会对变量修改

let x:&str =  'hellp';  // 重新声明可以覆盖原变量和类型
```

常量：

```rust
// 常量始终不可变，需定义类型
// 命名约定是全部字母都使用大写，并使用下划线分隔单词
const THREE_HOURS_IN_SECONDS: u32 = 60 * 60 * 3;
```

作用域：

```rust
let x = 5
let x = x + 1
{
  let x = x * 2
  println!("the number of seconds {}",x) //12
}
println!("the number of seconds {}",x) // 6
```

数据类型-标量类型：

-   整型： 有符号 i8 i16 i32 i64 i28 范围-(2n - 1) ~ 2n - 1 - 1 无符号 u8 u16 u32 u64 u128 范围 0 ~ 2n - 1
-   浮点型：皆带符号可以取负值 f32 f64(默认，现代计算器无差别)
-   布尔型：bool 声明 true 和 false
-   字符：char 4 个字节

数据类型-复合类型：

-   元祖：多个类型值的组合，长度固定，声明后无法更改

```rust
let tup: (i32, f64, u8) = (500, 6.4, 1);
// 解构取值
let (x, y, z) = tup;
println!("The value of y is: {}", y); // 6.4
// 索引访问
let five_hundred = tup.0; // 500
```

-   数组：单个类型值的组合 长度固定不可更改

```rust
// 声明类型为整型长度为5
let x:[u32;5] = [1,2,3,4,5]
// 指定每个元素初始值3
let a = [3; 5];
// 索引访问 超出访问报错
x[0] // 3
x[6] //error
```

函数：

```rust
fn main() {
    let y = {
        let x = 3;
        x + 1 // 无分号表示非语句 可以返回绑定给y
    };

    println!("The value of y is: {}", y); // 4
}

fn five(x:i32) -> i32 { // 指定参数和返回值类型
    x+5
}
```

控制流：

-   if

```rust
let num = 5;
// 条件必须是 bool 值
if num > 2 {
  println!("condition was true");
} else {
  println!("condition was false");
}

let condition = true;
// 返回值都必须是相同类型
let number = if condition { 5 } else { 6 };
```

-   loop

```rust
let mut count = 0;
'counting_up: loop {
  let mut num = 0;
  loop {
    println!("loop");
    num += 1;
    if num > 5 {
      break; // 跳出循环
    }else if num == 2 {
      continue; // 跳过这个循环到下一个循环
    }
    if count == 2 {
      break 'counting_up'; // 跳出外层循环
    }
    println!("num is {}",num);
  }
  count += 1;
}

let mut counter = 0;
let result = loop {
    counter += 1;
    if counter == 10 {
        break counter * 2; // 循环返回赋值
    }
};
```

-   while

```rust
let mut number = 3;

while number != 0 {
    println!("{}!", number);
    number -= 1;
}
```

-   for

```rust
let a = [1,2,3,4,5]
for element in a {
    println!("the value is: {}", element);
}
```

所有权：

```rust
// String 的底层由指针、长度和容量构成 指针指向内存数据
let s1 = String::from("hello");
let s2 = s1; // s2只会拷贝它的指针、长度和容量 而不会拷贝指针指向数据
// s2被赋值后 此时s1会失效 rust称之为移动 s2离开作用域时内存会被释放

// 报错  rust的内存回收机制为 当变量离开作用域被释放
println!("{}, world!", s1);
```

```rust
// 深度复制 String
let s1 = String::from("hello");
let s2 = s1.clone();

println!("s1 = {}, s2 = {}", s1, s2);
```

```rust
  let x = 5;
  let y = x; // 整型类型会直接存储在栈上， x不会失效

  println!("x = {}, y = {}", x, y);
```

```rust
// 将值传递给函数在语义上与给变量赋值相似
fn main() {
  let s = String::from("hello");  // s 进入作用域

  let l = takes_ownership(s);   // s 的值移动到函数里 ...
                  // ... 所以到这里不再有效 使用s会报错
  let x = 5;      // x 进入作用域
  makes_copy(x);  // x 应该移动函数里，
                  // 但 i32 是 Copy 的，所以在后面可继续使用 x
}

fn gives_ownership() -> String {           // gives_ownership 将返回值移动给
                                           // 调用它的函数

  let some_string = String::from("yours"); // some_string 进入作用域

  some_string                              // 返回 some_string 并移出给调用的函数
}
```

-   引用：& 允许你使用值但不获取其所有权

```rust
// 引用而非移动
fn main() {
    let s1 = String::from("hello");

    let len = calculate_length(&s1); // 引用 创建一个指向值s1的引用

    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}
```

-   可变和不可变引用

```rust
let mut x = String::from("hello");
let s1 = &x;
let s2 = &x;
//一个不可变引用的作用域从声明的地方开始一直持续到最后一次使用为止
println!("s1{},s1{}", s1, s2); // 此后作用域被释放，所以在此后可以声明可变引用

let s3 = &mut x; // 可变引用

```

-   悬垂引用：可能其指向的内存可能已经被释放或者移动 保留的指针就会生成一个悬垂指针

```rust
fn main() {
    let reference_to_nothing = dangle();
}

fn dangle() -> &String {
    let s = String::from("hello");

    // 因为s被释放 指向被移动
    &s // 此后s被释放 &s留的指针就会生成一个悬垂指针错误
}
// 正确
fn no_danger() -> String {
  let s = String::from("hello");

  s // 所有权被转移出去
}
```

-   slice 引用

```rust
let s = String::from("hello world");
// 部分引用
let hello = &s[0..5]; // hello

let arr = [1,2,3,4,5]
let arr2 = &arr[1..2] // [2,3]
```

结构体：可以定义和包装多种数据的组合

```rust
// 定义结构体
struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}

// 使用结构体-结构体实例
let mut user1 = User {
  email: String::from("someone@example.com"),
  username: String::from("someusername123"),
  active: true,
  sign_in_count: 1,
}

let user2 = User {
    email: String::from("another@example.com"),
    ..user1 // 指定剩余未声明字段值与user1一致 但因为user1中未实现copy类型被移动了(类似=赋值) 所以user1会失效
};

struct Color(i32, i32, i32);

let black = Color(0,0,0);
```

```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle { //impl 实现结构体并定义 area 方法
    fn area(&self) -> u32 { // 参数为Rectangle实例
        self.width * self.height
    }
}

// 可以多个impl实现
impl Rectangle {
    fn can_hold(&self, other: &Rectangle) -> bool { //也可接受其他参数
        self.width > other.width && self.height > other.height
    }
}

fn main() {
    let rect1 = Rectangle {
        width: 30,
        height: 50,
    };
    let rect2 = Rectangle {
        width: 30,
        height: 50,
    };

    println!(
        "The area of the rectangle is {} square pixels.",
        rect1.area() // 只引用值
    );

    println!("Can rect1 hold rect2? {}", rect1.area(&rect2));
}
```
