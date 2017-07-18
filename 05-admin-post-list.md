# 管理后台文章管理

## 展示全部文章数据列表

### 查询文章数据

```sql
select * from posts;
```

在文章列表页通过执行以上 SQL 语句获取全部文章数据：

```php
// 查询全部文章数据
$posts = xiu_query('select * from posts');
```

### 基本的文章数据绑定

在表格中将多余的 `<tr>` 标记移除，通过 `foreach` 遍历查询到的 `$posts` 变量，绑定数据：

> 名词解释：
> **数据绑定**是指将一个有结构的数据输出到特定结构的 HTML 上。

```php
<?php foreach ($posts as $item) { ?>
<tr>
  <td class="text-center"><input type="checkbox"></td>
  <td><?php echo $item['title']; ?></td>
  <td><?php echo $item['user_id']; ?></td>
  <td><?php echo $item['category_id']; ?></td>
  <td><?php echo $item['created']; ?></td>
  <td><?php echo $item['status']; ?></td>
  <td class="text-center">
    <a href="post-add.php" class="btn btn-default btn-xs">编辑</a>
    <a href="javascript:;" class="btn btn-danger btn-xs">删除</a>
  </td>
</tr>
<?php } ?>
```

> 🚩 源代码: step-19

---

## 数据过滤输出

Sometimes, 我们希望在界面上看到的数据并不是数据库中原始的数据，而是经过一个特定的转换逻辑转换过后的结果。这种情况经常发生在输出时间、状态和关联数据时。

### 文章状态友好展示

一般情况下，我们在数据库存储标识都用英文或数字方式存储，但是在界面上应该展示成中文方式，所以我们需要在输出的时候做一次转换，转换方式就是定义一个转换函数：

```php
/**
 * 将英文状态描述转换为中文
 * @param  string $status 英文状态
 * @return string         中文状态
 */
function convert_status ($status) {
  switch ($status) {
    case 'drafted':
      return '草稿';
    case 'published':
      return '已发布';
    case 'trashed':
      return '回收站';
    default:
      return '未知';
  }
}
```

在输出时调用这个函数：

```php
<td class="text-center"><?php echo convert_status($item['status']); ?></td>
```

### 日期格式化展示

如果需要自定义发布时间的展示格式，可以通过 `date()` 函数完成，而 `date()` 函数所需的参数除了控制输出格式的 `format` 以外，还需要一个整数类型的 `timestamp`。

> http://php.net/manual/zh/function.date.php

我们已有的是一个类似于 `2012-12-12 12:00:00` 具有标准时间格式的字符串，必须转换成整数类型的 `timestamp`，才能调用 `date()` 函数。我们可以借助 `strtotime()` 函数完成时间字符串到时间戳（timestamp）的转换：

> http://php.net/manual/zh/function.strtotime.php
> - 在使用 `strtotime()` 之前，确保通过 `date_default_timezone_set()` 设置默认时区

于是乎，定义一个格式化日期的转换函数：

```php
/**
 * 格式化日期
 * @param  string $created 时间字符串
 * @return string          格式化后的时间字符串
 */
function format_date ($created) {
  // 设置默认时区！！！
  date_default_timezone_set('UTC');

  // 转换为时间戳
  $timestamp = strtotime($created);

  // 格式化并返回 由于 r 是特殊字符，所以需要 \r 转义一下
  return date('Y年m月d日 <b\r> H:i:s', $timestamp);
}
```

在输出的位置调用此函数：

```php
<td class="text-center"><?php echo format_date($item['created']); ?></td>
```

> 🚩 源代码: step-20

### 关联数据查询展示

#### 分类信息展示

我们在文章表中存储的分类信息就只是分类的 ID，直接输出到表格中，并不友好，所以我们需要在输出分类信息时再次根据分类 ID 查询对应文章的分类信息，将查询到的结果输出到 HTML 中。

定义一个根据分类 ID 获取分类信息的函数：

```php
/**
 * 根据 ID 获取分类信息
 * @param  integer $id 分类 ID
 * @return array       分类信息关联数组
 */
function get_category ($id) {
  $sql = sprintf('select * from categories where id = %d', $id);
  return xiu_query($sql)[0];
}
```

在输出分类名称的位置通过调用该函数输出分类名称：

```php
<td><?php echo get_category($item['category_id'])['name']; ?></td>
```

#### 作者信息展示

同上所述，按照相同的方式查询文章的作者信息并输出：

```php
/**
 * 根据 ID 获取用户信息
 * @param  integer $id 用户 ID
 * @return array       用户信息关联数组
 */
function get_author ($id) {
  $sql = sprintf('select * from users where id = %d', $id);
  return xiu_query($sql)[0];
}
```

在输出作者的位置通过调用该函数输出作者昵称：

```php
<td><?php echo get_author($item['user_id'])['nickname']; ?></td>
```

> 🚩 源代码: step-21

### 联合查询，一步到位

按照以上的方式，可以正常输出分类和作者信息，但是过程中需要有大量的数据库连接和查询操作。

在实际开发过程中，一般不这么做，通常我们会使用联合查询的方式，同时把我们需要的信息查询出来：

```sql
select *
from posts
inner join users on posts.user_id = users.id
inner join categories on posts.category_id = categories.id;
```

以上这条语句可以把 `posts`、`users`、`categories` 三张表同时查询出来（查询到一个结果集中）。

所以我们可以移除 `get_category` 和 `get_author` 两个函数，将查询语句改为上面定义的内容，完成一次性查询。

> 🚩 源代码: step-22

这样查询也有一些小问题：如果这几个表中有相同名称的字段，在查询过后转换为关联数组就会有问题（关联数组的键是不能重复的），所以我们需要指定需要查询的字段，同时还可以给每一个字段起一个别名，避免冲突：

```sql
select
  posts.id,
  posts.title,
  posts.created,
  posts.status,
  categories.name as category_name,
  users.nickname as author_name
from posts
inner join users on posts.user_id = users.id
inner join categories on posts.category_id = categories.id;
```

从另外一个角度来说：指定了具体的查询字段，也会提高数据库检索的速度。

> 🚩 源代码: step-23

---

## 分页加载文章数据

**导入更多的测试数据**

[测试数据导入脚本](media/posts-test-data.sql)

### 查询一部分数据

当数据过多过后，如果还是按照以上操作每次查询全部数据，页面就显得十分臃肿，加载起来也非常慢，所以必须要通过分页加载的方式改善（每次只显示一部分数据）。

操作方式也非常简单，就是在原有 SQL 语句的基础之上加上 `limit` 和 `order by` 子句：

```sql
select
  posts.id,
  posts.title,
  posts.created,
  posts.status,
  categories.name as category_name,
  users.nickname as author_name
from posts
inner join users on posts.user_id = users.id
inner join categories on posts.category_id = categories.id
order by posts.created desc
limit 0, 10
```

> limit 用法：limit [offset, ]rows
> - `limit 10` -- 只取前 10 条数据
> - `limit 5, 10` -- 从第 5 条之后，第 6 条开始，向后取 10 条数据

### 分页参数计算

`limit` 子句中的 `0` 和 `10` 不是一成不变的，应该跟着页码的变化而变化，具体的规则就是：

- 第 1 页 `limit 0, 10`
- 第 2 页 `limit 10, 10`
- 第 3 页 `limit 20, 10`
- 第 4 页 `limit 30, 10`
- ...

根据以上规则得出公式：`offset = (page - 1) * size`

```php
// 处理分页
// ========================================

$size = 10;
$page = 2;

// 查询数据
// ========================================

// 查询全部文章数据
$posts = xiu_query(sprintf('select
  posts.id,
  posts.title,
  posts.created,
  posts.status,
  categories.name as category_name,
  users.nickname as author_name
from posts
inner join users on posts.user_id = users.id
inner join categories on posts.category_id = categories.id
order by posts.created desc
limit %d, %d', ($page - 1) * $size, $size));
```

> 🚩 源代码: step-24

### 获取当前页码

一般分页都是通过 URL 传递一个页码参数（通常使用 `querystring`）

也就是说，我们应该在页面开始执行的时候获取这个 URL 参数：

```php
// 处理分页
// ========================================

// 定义每页显示数据量（一般把这一项定义到配置文件中）
$size = 10;

// 获取分页参数 没有或传过来的不是数字的话默认为 1
$page = isset($_GET['p']) && is_numeric($_GET['p']) ? intval($_GET['p']) : 1;

if ($page <= 0) {
  // 页码小于 1 没有任何意义，则跳转到第一页
  header('Location: /admin/posts.php?p=1');
  exit;
}
```

> 🚩 源代码: step-25

### 展示分页跳转链接

用户在使用分页功能时不可能通过地址栏改变要访问的页码，必须通过可视化的链接点击访问，所以我们需要根据数据的情况在界面上显示分页链接。

![分页跳转链接](media/pagination.png)

> 目标效果演示：http://esimakin.github.io/twbs-pagination/

组合一个分页跳转链接的必要条件：

- 一共有多少页面（或者一共有多少条数据、每页显示多少条）
- 当前显示的时第几页
- 一共要在界面上显示多少个分页跳转链接，一般为单数个，如：3、5、7

以上必要条件中只有第一条需要额外处理，其余的目前都可以拿到，所以重点攻克第一条：

#### 获取总页数

一共有多少页面取决于一共有多少条数据和每一页显示多少条，计算公式为：`$total_pages = ceil($total_count / $size)`。

通过查询数据库可以得到总条数：

```php
// 查询总条数
$total_count = intval(xiu_query('select count(1)
from posts
inner join users on posts.user_id = users.id
inner join categories on posts.category_id = categories.id')[0][0]);

// 计算总页数
$total_pages = ceil($total_count / $size);
```

> 思考：为什么要在查询条数的时候也用联合查询

<!-- 答：数据严谨问题 -->

知道了总页数，就可以对 URL 中传递过来的分页参数做范围校验了（$page <= $totel_pages）

```php
if ($page > $total_pages) {
  // 超出范围，则跳转到最后一页
  header('Location: /admin/posts.php?p=' . $total_pages);
  exit;
}
```

> 🚩 源代码: step-26

#### 循环输出分页链接

```php
<ul class="pagination pagination-sm pull-right">
  <?php if ($page - 1 > 0) : ?>
  <li><a href="?p=<?php echo $page - 1; ?>">上一页</a></li>
  <?php endif; ?>
  <?php for ($i = 1; $i <= $total_pages; $i++) : ?>
  <li<?php echo $i === $page ? ' class="active"' : '' ?>><a href="?p=<?php echo $i; ?>"><?php echo $i; ?></a></li>
  <?php endfor; ?>
  <?php if ($page + 1 <= $total_pages) : ?>
  <li><a href="?p=<?php echo $page + 1; ?>">下一页</a></li>
  <?php endif; ?>
</ul>
```

> 🚩 源代码: step-27

由于分页功能在不同页面都会被使用到，所以也提取到 `functions.php` 文件中，封装成一个 `xiu_pagination` 函数：

```php
/**
 * 输出分页链接
 * @param  integer $page   当前页码
 * @param  integer $total  总页数
 * @param  string  $format 链接模板，%d 会被替换为具体页数
 * @example
 *   <?php xiu_pagination(2, 10, '/list.php?page=%d'); ?>
 */
function xiu_pagination ($page, $total, $format) {
  // 上一页
  if ($page - 1 > 0) {
    printf('<li><a href="%s">上一页</a></li>', sprintf($format, $page - 1));
  }

  // 数字页码
  for ($i = 1; $i <= $total; $i++) {
    $activeClass = $i === $page ? ' class="active"' : '';
    printf('<li%s><a href="%s">%d</a></li>', $activeClass, sprintf($format, $i), $i);
  }

  // 下一页
  if ($page + 1 <= $total) {
    printf('<li><a href="%s">下一页</a></li>', sprintf($format, $page + 1));
  }
}
```

> 🚩 源代码: step-28

#### 控制显示页码个数

按照目前的实现情况，已经可以正常使用分页链接了，但是当总页数过多，显示起来也会有问题，所以需要控制显示页码的个数，一般情况下，我们是根据当前页码在中间，左边和右边各留几位。

实现以上需求的思路：主要就是想办法根据当前页码知道应该从第几页开始显示，到第几页结束，另外需要注意不能超出范围。

以下是具体实现：

```php
/**
 * 输出分页链接
 * @param  integer $page    当前页码
 * @param  integer $total   总页数
 * @param  string  $format  链接模板，%d 会被替换为具体页数
 * @param  integer $visible 可见页码数量（可选参数，默认为 5）
 * @example
 *   <?php xiu_pagination(2, 10, '/list.php?page=%d', 5); ?>
 */
function xiu_pagination ($page, $total, $format, $visible = 5) {
  // 计算起始页码
  // 当前页左侧应有几个页码数，如果一共是 5 个，则左边是 2 个，右边是两个
  $left = floor($visible / 2);
  // 开始页码
  $begin = $page - $left;
  // 确保开始不能小于 1
  $begin = $begin < 1 ? 1 : $begin;
  // 结束页码
  $end = $begin + $visible - 1;
  // 确保结束不能大于最大值 $total
  $end = $end > $total ? $total : $end;
  // 如果 $end 变了，$begin 也要跟着一起变
  $begin = $end - $visible + 1;
  // 确保开始不能小于 1
  $begin = $begin < 1 ? 1 : $begin;

  // 上一页
  if ($page - 1 > 0) {
    printf('<li><a href="%s">&laquo;</a></li>', sprintf($format, $page - 1));
  }

  // 省略号
  if ($begin > 1) {
    print('<li class="disabled"><span>···</span></li>');
  }

  // 数字页码
  for ($i = $begin; $i <= $end; $i++) {
    // 经过以上的计算 $i 的类型可能是 float 类型，所以此处用 == 比较合适
    $activeClass = $i == $page ? ' class="active"' : '';
    printf('<li%s><a href="%s">%d</a></li>', $activeClass, sprintf($format, $i), $i);
  }

  // 省略号
  if ($end < $total) {
    print('<li class="disabled"><span>···</span></li>');
  }

  // 下一页
  if ($page + 1 <= $total) {
    printf('<li><a href="%s">&raquo;</a></li>', sprintf($format, $page + 1));
  }
}
```

> 🚩 源代码: step-29

---

## 数据筛选

### 状态筛选

> 注意：不要立即联想 AJAX 的问题，AJAX 是后来诞生的，换而言之不是必须的，我们这里讨论的只是传统的方式（历史使人明智）

实现思路：用户只有在未筛选的情况下知道一共有哪些状态，当用户选择其中某个状态过后，必须让服务端知道用户选择的状态是什么，从而返回指定的状态下的数据。

```sequence
Note left of 客户端: 不知道服务端有什么
客户端->服务端: 第一次请求(没有筛选)
Note right of 服务端: 查询任意状态的数据
服务端->客户端: 第一次响应，返回全部数据
Note left of 客户端: 客户端表格显示数据
客户端->服务端: 第二次请求，告诉服务端我要什么状态的数据
Note right of 服务端: 查询指定状态的数据
服务端->客户端: 第二次响应，返回筛选过后的数据
```

> **好有一比**：去商店买钻石，你不可能直接说来颗 5 斤的，正常情况，你都是先问有没有钻石，售货员拿出一排，顺便告诉你有哪几种重量的，你再告诉售货员你选其中哪一种，售货员再拿出指定种类的让你挑。

所以我们先在页面上添加一个表单（用于接收用户后续的意愿），然后提供一个 `<select>` 列出全部状态，让用户选择。用户选择完了再把表单提交回来，此时服务端就知道你需要什么状态的数据。

> 注意：永远都不要说历史上的事 low，历史永远是伟大的。

#### 表单 HTML 处理

不设置表单的 method 默认就是 get，此处就应该使用 get，原因有二：

- 效果上：get 提交的参数会体现在 URL 中，方便用户使用（刷新、书签）
- 性质上：这一次请求主观上还是在**拿（获取）**服务端的数据

```php
<form class="form-inline" action="/admin/posts.php">
  <select name="s" class="form-control input-sm">
    <option value="all">所有状态</option>
    <option value="drafted">草稿</option>
    <option value="published">已发布</option>
    <option value="trashed">回收站</option>
  </select>
  <button class="btn btn-default btn-sm">筛选</button>
</form>
```

#### 获取提交参数

在查询数据之前，接受参数，组织查询参数：

```php
// 处理筛选逻辑
// ========================================

// 数据库查询筛选条件（默认为 1 = 1，相当于没有条件）
$where = '1 = 1';

// 状态筛选
if (isset($_GET['s']) && $_GET['s'] != 'all') {
  $where .= sprintf(" and posts.status = '%s'", $_GET['s']);
}

// $where => " and posts.status = 'drafted'"
```

#### 添加查询参数

然后在进行查询时添加 `where` 子句：

```php
// 查询总条数
$total_count = intval(xiu_query('select count(1)
from posts
inner join users on posts.user_id = users.id
inner join categories on posts.category_id = categories.id
where ' . $where)[0][0]);

...

// 查询全部文章数据
$posts = xiu_query(sprintf('select
  posts.id,
  posts.title,
  posts.created,
  posts.status,
  categories.name as category_name,
  users.nickname as author_name
from posts
inner join users on posts.user_id = users.id
inner join categories on posts.category_id = categories.id
where %s
order by posts.created desc
limit %d, %d', $where, ($page - 1) * $size, $size));
```

> 🚩 源代码: step-30

#### 记住筛选状态

筛选后，`<select>` 中被选中的 `<option>` 应该在展示的时候默认选中：

```php
<select name="s" class="form-control input-sm">
  <option value="all">所有状态</option>
  <option value="drafted"<?php echo isset($_GET['s']) && $_GET['s'] == 'drafted' ? ' selected' : ''; ?>>草稿</option>
  <option value="published"<?php echo isset($_GET['s']) && $_GET['s'] == 'published' ? ' selected' : ''; ?>>已发布</option>
  <option value="trashed"<?php echo isset($_GET['s']) && $_GET['s'] == 'trashed' ? ' selected' : ''; ?>>回收站</option>
</select>
```

> 🚩 源代码: step-31

### 分类筛选

> ✏️ 作业：
> 仿照状态筛选功能的实现过程，实现分类筛选功能

<!-- 思路：分类筛选功能就是在状态筛选功能基础之上，多了一个初始分类列表的展示（状态是固定的，分类是需要查数据库的） -->

> 🚩 源代码: step-32

### 结合分页

目前来说，单独看筛选功能和分页功能都是没有问题，但是同时使用会有问题：

1. 筛选过后，页数不对（没有遇到，但是常见）。
  - 原因：查询总条数时没有添加筛选条件
2. 筛选过后，点分页链接访问其他页，筛选状态丢失。
  - 原因：分类链接的 URL 中只有页码信息，不包括筛选状态

#### 分页链接加入筛选参数

只要在涉及到分页链接的地方加上当前的筛选参数即可解决问题，所以我们在接收状态筛选参数时将其记录下来：

```php
// 记录本次请求的查询参数
$query = '';

// 状态筛选
if (isset($_GET['s']) && $_GET['s'] != 'all') {
  $where .= sprintf(" and posts.status = '%s'", $_GET['s']);
  $query .= '&s=' . $_GET['s'];
}

// 分类筛选
if (isset($_GET['c']) && $_GET['c'] != 'all') {
  $where .= sprintf(" and posts.category_id = %d", $_GET['c']);
  $query .= '&c=' . $_GET['c'];
}

// $query => "&s=drafted&c=2"
```

> 🚩 源代码: step-33
