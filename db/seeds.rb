# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create({
  email: "user1@user.com", 
  password: "password"
})

Funnel.create({
  name: "True",
  goal: "emails",
  user_id: 1
})

Step.create([{
  url: "https://trueandco.com/quiz/best-bras-ever",
  funnel_id: 1
}, {
  url: "https://trueandco.com/quiz/",
  funnel_id: 1
}])