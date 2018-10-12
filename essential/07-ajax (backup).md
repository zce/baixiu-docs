# AJAX

## 概述

AJAX（Asynchronous JavaScript and XML），最早出现在 2005 年的 Google Suggest，是一种通过 JavaScript 进行网络编程（发送请求、接收响应）的技术方案，它使我们可以获取和显示新的内容而不必载入一个新的 Web 页面。增强用户体验，更有桌面程序的感觉。

说白了，AJAX 就是浏览器提供的一套 API，可以通过 JavaScript 调用，从而实现代码控制请求与响应。

**AJAX 与 页面局部内容刷新 不完全等价**，AJAX 可以做页面局部内容刷新

能够让浏览器发出请求报文的几种方式

1. 地址栏
2. href
3. src
4. form + submit


如果 JavaScript 可以发送请求 接收响应
我们能通过 Js 实现的功能


- 单机 弹出对话框  轮播  选项卡

## 基本使用

> http://www.w3school.com.cn/ajax/index.asp

```javascript
// 1、创建XMLHttpRequest对象
var xhr = new XMLHttpRequest();
// 2、准备发送
xhr.open('get', './01check.php?username=' + uname + '&password=' + pw, true);
// 3、执行发送动作
xhr.send(null);
// 4、指定回调函数
xhr.onreadystatechange = function () {
  if (xhr.readyState === 4) {
    if (xhr.status === 200) {
      // 获取响应数据
      var data = xhr.responseText;
      var info = document.getElementById('info');
      if (data === '1') {
        info.innerHTML = '登录成功';
      } else if (data === '2') {
        info.innerHTML = '用户名或者密码错误';
      }
    }
  }
}
```

### 过程细节分析

- xhr对象创建兼容处理
- 请求方式分析
  - get
  - post
- 响应状态分析
  - readyState
  - status
- 响应内容分析
  - responseText
  - responseXML
- xml与json数据格式分析
  - xml基本规则
  - json基本规则
- 回调函数执行流程分析
  - 异步执行流程分析

## 封装函数

```javascript
function ajax(url, type,param,dataType,callback){
    var xhr = null;
    if(window.XMLHttpRequest){
        xhr = new XMLHttpRequest();
    }else{
        xhr = new ActiveXObject('Microsoft.XMLHTTP');
    }
    if(type == 'get'){
        url += "?" + param;
    }
    xhr.open(type,url,true);

    var data = null;
    if(type == 'post'){
        data = param;
        xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    }
    xhr.send(data);
    xhr.onreadystatechange = function(){
        if(xhr.readyState == 4){
            if(xhr.status == 200){
                var data = xhr.responseText;
                if(dataType == 'json'){
                    data = JSON.parse(data);
                }
                callback(data);
            }
        }
    }
}
```