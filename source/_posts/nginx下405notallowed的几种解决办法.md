---
title: nginx下405notallowed的几种解决办法
tags:
  - javascript
  - nginx
  - https
categories: 开发相关
date: 2018-02-05 10:49:35
---
接近年底,闲来无事,刚好在网上看到一个https的帖子,https现在已经成为潮流,就想着闲来无事不如把自己以前的一些项目也都部署转成https的.从https证书部署到nginx代理配置再到成功看到浏览器中的小锁头一切都顺利的走了下来,心里想着https配置也挺简单嘛,结果直到几天后某一天,终于发生了一件大事......好了,不乱扯了,开始正题:

今天在无意间测试一个项目的上传功能时发现,当用post方式去请求一个静态文件时，会报错,返回 HTTP/1.1 405 Method not allowed 状态，无法正常显示页面。 

最终经过本人不懈的百度 google后,采集了各方意见,逐一测试后解决了这个bug,这里贴出我测试的几个方法,是否有用,以实际代码为准,下面我会逐各进行原理说明:

### 方法一

>server
{
   listen       80;
   server_name  test.baidu.com;
   index index.html index.htm index.php;
   root  /www/test.baidu.com;
   error_page   405 =200 @405;
   location @405
   {
       root  /www/test.baidu.com;
   }    
  location ~ .*.php?$
   {
       include conf/fcgi.conf;     
       fastcgi_pass  127.0.0.1:9000;
       fastcgi_index index.php;
   }
}

方法一主要利用了nginx的代理转发,把错误码405 notallowed 转发到200 然后完成正常的post请求,这其实也是对浏览器的一种欺骗.



### 方法二

编辑nginx源代码
vi /root/soft/nginx1.0.10/src/http/modules/ngx_http_static_module.c

``` bash
注释掉原有的一段话
/*   
 if (r->method & NGX_HTTP_POST) {
        return NGX_HTTP_NOT_ALLOWED;
       }
*/
```
然后按照原来的编译参数  ./configuer  make  不用make install 否则会覆盖原来的一些配置文件。
执行

``` bash
cp  $nginx_dir/sbin/nginx  $nginx_dir/sbin/nginx.bak
cp ./objs/nginx   $nginx_dir/sbin/nginx
$nginx_dir/sbin/nginx -s reload
```

方法二主要利用了对nginx源码的编辑,修改了nginx原有的post禁止的机制,进而避免了405 not allowed的状态.



### 方法三

>server
{
   listen       80;
   server_name  test.baidu.com;
   index index.html index.htm index.php;
   root  /www/test.baidu.com;
     location /
    {
      root /www/test.baidu.com;
      error_page 405 =200 http://$host$request_uri;
      }
      location ~ .*.php?$
   {
       include conf/fcgi.conf;    
       fastcgi_pass  127.0.0.1:9000;
       fastcgi_index index.php;
   }
}

方法三和方法一原理类似,都是把错误码405 notallowed 转发到200 然后完成正常的post请求.



