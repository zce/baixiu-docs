# HTTP 会话

## Cookie

HTTP 很重要的一个特点就是**无状态**（每一次见面都是“初次见面”），如果单纯的希望通过我们的服务端程序去记住每一个访问者是不可能的，所以必须借助一些手段或者说技巧让服务端记住客户端，这种手段就是 **Cookie**。

![cookie](media/cookie.png)

Cookie 就像是在超级市场买东西拿到的小票，由超市（Server）发给消费者（Browser），超市方面不用记住每一个消费者的脸，但是他们认识消费者手里的小票（Cookie），可以通过小票知道消费者之前的一些消费信息（在服务端产生的数据）。

### PHP 中操作 Cookie

> http://php.net/manual/zh/function.setcookie.php

```php
// 设置 cookie
setcookie("TestCookie", "hello", time() + 3600);  /* 1 小时过期  */
// 获取 cookie
echo $_COOKIE["TestCookie"];
```

#### 记住登录名案例

##### 登录功能实现流程

```sequence
客户端->服务端: Request GET /login.php
服务端->客户端: Response 空白表单页面
Note left of 客户端: 用户填写表单
客户端->服务端: Request POST /login.php 表单数据
Note right of 服务端: 服务端对提交过来的数据进行校验
服务端->客户端: Response Location: /main.php\n跳转到 main.php
客户端-->服务端: Request GET /main.php
服务端-->客户端: Response Welcome
Note over 客户端,服务端: ..........
客户端->服务端: Request GET /login.php
服务端->客户端: Response 空白表单页面
```



### JavaScript 中操作 Cookie

#### Pure JavaScript

> 参考：http://www.runoob.com/js/js-cookies.html

```javascript
// 新增一条 cookie，注意：cookie 是有大小限制，约为 4k
//   格式固定：<key>=<value>[; expires=<GMT格式时间>][; path=<作用路径>][; domain=<作用域名>]
//   除了键值以外其余属性均有默认值，可以省略
//   expires 表示 cookie 失效的时间，默认为关闭浏览器时
//   path 表示 cookie 生效的路径，默认为当路径
//       /   /foo.php   /abc/foo.php
//       /foo     /bar/abc.php
//   domain 表示 cookie 生效的域名，默认为当前域名

document.cookie = 'name=value; expires=Tue, 10 Oct 2017 16:14:47 GMT; path=/; domain=zce.me'
// 获取全部 cookie
console.log(document.cookie)
// => 'key1=value1; key2=value2'
// 得到的结果是字符串，需要自己通过字符串操作解析
```

#### jQuery plugin

https://github.com/carhartl/jquery-cookie

#### without jQuery

https://github.com/js-cookie/js-cookie

## Session

由于 Cookie 是服务端下发给客户端**由客户端本地保存**的。换而言之客户端可以在本地对其随意操作，包括删除和修改。如果客户端随意伪造一个 Cookie 的话，对于服务端是无法辨别的，就会造成服务端被蒙蔽，构成安全隐患。

于是乎就有了另外一种基于 Cookie 基础之上的手段：**Session**：

![session-structure](media/session-structure.png)

Session 区别于 Cookie 一个很大的地方就是：Session 数据存在了服务端，而 Cookie 存在了客户端本地，存在服务端最大的优势就是，不是用户想怎么改就怎么改了。

Session 这种机制会更加适合于存放一些属于用户而又不能让用户修改的数据，因为客户端不再保存具体的数据，只是保存一把“钥匙”，伪造一把可以用的钥匙，可能性是极低的，所以不需要在意。

![session-flow](media/session-flow.png)

> http://php.net/manual/zh/session.examples.basic.php