admin = User.create(username: 'Jon', password: '1111', role: 'admin')
c1 = User.create(username: 'Toni', password: '1111', role: 'content providers')
c2 = User.create(username: 'Joni', password: '1111', role: 'content providers')

Page.create(title: 'test1', content: 'some', user_id: admin.id)
Page.create(title: 'test2', content: 'some', user_id: c1.id)
Page.create(title: 'test3', content: 'some', user_id: c2.id)