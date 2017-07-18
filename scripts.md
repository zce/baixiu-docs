Random.extend({
  status () {
    var status = ['drafted', 'published', 'trashed']
    return this.pick(status)
  }
})

const posts = []

for (let i = 0; i < 500; i++) {
  posts.push({
    slug: Random.word(),
    title: Random.ctitle(),
    feature: Random.image('800x600', Random.color(), 'zce.me'),
    created: Random.datetime(),
    content: Random.cparagraph(8, 14),
    views: Random.integer(0, 200),
    likes: Random.integer(0, 200),
    status: Random.status(),
    user_id: Random.integer(1, 3),
    category_id: Random.integer(1, 4)
  })
}

posts.sort((a, b) => new Date(a.created) - new Date(b.created))

const querys = posts.map(item => `insert into posts values(null, '${item.slug}', '${item.title}', '${item.feature}', '${item.created}', '${item.content}', ${item.views}, ${item.likes}, '${item.status}', ${item.user_id}, ${item.category_id});`)

console.log(querys.join('\n'))


-------------------------------------------------------------------------------

Random.extend({
  status () {
    var status = ['held', 'approved', 'rejected', 'trashed']
    return this.pick(status)
  }
})

const comments = []

for (let i = 0; i < 500; i++) {
  comments.push({
    author: Random.cname(),
    email: Random.email(),
    created: Random.datetime(),
    content: Random.cparagraph(3, 5),
    status: Random.status(),
    post_id: Random.integer(1, 10),
    parent_id: Random.integer(1, 7)
  })
}

comments.sort((a, b) => new Date(a.created) - new Date(b.created))

const querys = comments.map(item => `insert into comments values(null, '${item.author}', '${item.email}', '${item.created}', '${item.content}', '${item.status}', ${item.post_id}, ${item.parent_id});`)

console.log(querys.join('\n'))

