-- phpMyAdmin SQL Dump
-- version 4.7.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 2017-07-11 04:21:14
-- 服务器版本： 5.7.18
-- PHP Version: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `baixiu`
--

-- --------------------------------------------------------

--
-- 表的结构 `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL COMMENT '主键',
  `slug` varchar(200) NOT NULL COMMENT '别名',
  `name` varchar(200) NOT NULL COMMENT '分类名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `categories`
--

INSERT INTO `categories` (`id`, `slug`, `name`) VALUES
(1, 'uncategorized', '未分类'),
(2, 'funny', '奇趣事'),
(3, 'living', '会生活'),
(4, 'travel', '爱旅行');

-- --------------------------------------------------------

--
-- 表的结构 `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL COMMENT '主键',
  `author` varchar(100) NOT NULL COMMENT '作者',
  `email` varchar(200) NOT NULL COMMENT '邮箱',
  `created` datetime NOT NULL COMMENT '创建时间',
  `content` varchar(1000) NOT NULL COMMENT '内容',
  `status` varchar(20) NOT NULL COMMENT '状态（held/approved/rejected/trashed）',
  `post_id` int(11) NOT NULL COMMENT '文章 ID',
  `parent_id` int(11) DEFAULT NULL COMMENT '父级 ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `comments`
--

INSERT INTO `comments` (`id`, `author`, `email`, `created`, `content`, `status`, `post_id`, `parent_id`) VALUES
(1, '汪磊', 'w@zce.me', '2017-07-04 12:00:00', '这是一条测试评论，欢迎光临', 'approved', 1, NULL),
(2, '嘿嘿', 'ee@gmail.com', '2017-07-05 09:10:00', '想知道香港回归的惊人内幕吗？快快与我取得联系', 'rejected', 1, NULL),
(3, '小右', 'www@gmail.com', '2017-07-06 14:10:00', '你好啊，交个朋友好吗？', 'held', 1, NULL),
(4, '汪磊', 'www@gmail.com', '2017-07-09 22:22:00', '不好', 'held', 1, 3),
(5, '汪磊', 'w@zce.me', '2017-07-09 18:22:00', 'How are you?', 'held', 1, 3),
(6, '小右', 'www@gmail.com', '2017-07-11 22:22:00', 'I am fine thank you and you?', 'held', 1, 5),
(7, '哈哈', 'hh@gmail.com', '2017-07-22 09:10:00', '一针见血', 'approved', 1, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `options`
--

CREATE TABLE `options` (
  `id` int(11) NOT NULL COMMENT '主键',
  `key` varchar(200) NOT NULL COMMENT '属性键',
  `value` text NOT NULL COMMENT '属性值'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `options`
--

INSERT INTO `options` (`id`, `key`, `value`) VALUES
(1, 'site_url', 'http://localhost'),
(2, 'site_logo', '/static/assets/img/logo.png'),
(3, 'site_name', '阿里百秀 - 发现生活，发现美！'),
(4, 'site_description', '阿里百秀同阿里巴巴有咩关系，答案当然系一啲都冇'),
(5, 'site_keywords', '生活, 旅行, 自由, 诗歌, 科技'),
(6, 'site_footer', '<p>© 2016 XIU主题演示 本站主题由 themebetter 提供</p>'),
(7, 'comment_status', '1'),
(8, 'comment_reviewed', '1'),
(9, 'nav_menus', '[{\"icon\":\"fa fa-glass\",\"text\":\"奇趣事\",\"title\":\"奇趣事\",\"link\":\"/category/funny\"},{\"icon\":\"fa fa-phone\",\"text\":\"潮科技\",\"title\":\"潮科技\",\"link\":\"/category/tech\"},{\"icon\":\"fa fa-fire\",\"text\":\"会生活\",\"title\":\"会生活\",\"link\":\"/category/living\"},{\"icon\":\"fa fa-gift\",\"text\":\"美奇迹\",\"title\":\"美奇迹\",\"link\":\"/category/travel\"}]'),
(10, 'home_slides', '[{\"image\":\"/static/uploads/slide_1.jpg\",\"text\":\"轮播项一\",\"link\":\"https://zce.me\"},{\"image\":\"/static/uploads/slide_2.jpg\",\"text\":\"轮播项二\",\"link\":\"https://zce.me\"}]');

-- --------------------------------------------------------

--
-- 表的结构 `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL COMMENT '主键',
  `slug` varchar(200) NOT NULL COMMENT '别名',
  `title` varchar(200) NOT NULL COMMENT '标题',
  `feature` varchar(200) DEFAULT NULL COMMENT '特色图像',
  `created` datetime NOT NULL COMMENT '创建时间',
  `content` text COMMENT '内容',
  `views` int(11) NOT NULL DEFAULT '0' COMMENT '浏览数',
  `likes` int(11) NOT NULL DEFAULT '0' COMMENT '点赞数',
  `status` varchar(20) NOT NULL COMMENT '状态（drafted/published/trashed）',
  `user_id` int(11) NOT NULL COMMENT '用户 ID',
  `category_id` int(11) NOT NULL COMMENT '分类 ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `posts`
--

INSERT INTO `posts` (`id`, `slug`, `title`, `feature`, `created`, `content`, `views`, `likes`, `status`, `user_id`, `category_id`) VALUES
(1, 'hello-world', '世界，你好', '/uploads/2017/hello-world.jpg', '2017-07-01 08:08:00', '欢迎使用阿里百秀。这是您的第一篇文章。编辑或删除它，然后开始写作吧！', 222, 111, 'published', 1, 1),
(2, 'simple-post-2', '第一篇示例文章', NULL, '2017-07-01 09:00:00', '欢迎使用阿里百秀。这是一篇示例文章', 123, 10, 'drafted', 1, 1),
(3, 'simple-post-3', '第二篇示例文章', NULL, '2017-07-01 12:00:00', '欢迎使用阿里百秀。这是一篇示例文章', 20, 120, 'drafted', 1, 2),
(4, 'simple-post-4', '第三篇示例文章', NULL, '2017-07-01 14:00:00', '欢迎使用阿里百秀。这是一篇示例文章', 40, 100, 'drafted', 1, 3);

-- --------------------------------------------------------

--
-- 表的结构 `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL COMMENT '主键',
  `slug` varchar(200) NOT NULL COMMENT '别名',
  `email` varchar(200) NOT NULL COMMENT '邮箱',
  `password` varchar(200) NOT NULL COMMENT '密码',
  `nickname` varchar(100) DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(200) DEFAULT NULL COMMENT '头像',
  `bio` varchar(500) DEFAULT NULL COMMENT '简介',
  `status` varchar(20) NOT NULL COMMENT '状态（unactivated/activated/forbidden/trashed）'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `users`
--

INSERT INTO `users` (`id`, `slug`, `email`, `password`, `nickname`, `avatar`, `bio`, `status`) VALUES
(1, 'admin', 'admin@zce.me', 'wanglei', '管理员', '/static/uploads/avatar.jpg', NULL, 'activated'),
(2, 'zce', 'w@zce.me', 'wanglei', '汪磊', '/static/uploads/avatar.jpg', NULL, 'activated'),
(3, 'ice', 'ice@wedn.net', 'wanglei', '汪磊', '/static/uploads/avatar.jpg', NULL, 'activated');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `options`
--
ALTER TABLE `options`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`key`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD UNIQUE KEY `email` (`email`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键', AUTO_INCREMENT=15;
--
-- 使用表AUTO_INCREMENT `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键', AUTO_INCREMENT=504;
--
-- 使用表AUTO_INCREMENT `options`
--
ALTER TABLE `options`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键', AUTO_INCREMENT=11;
--
-- 使用表AUTO_INCREMENT `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键', AUTO_INCREMENT=315;
--
-- 使用表AUTO_INCREMENT `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键', AUTO_INCREMENT=5;COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
