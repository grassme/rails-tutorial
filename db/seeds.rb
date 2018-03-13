User.create!(name:  "Nguyễn Thị Huyền Lanh",
             email: "lanh.ptit.tn@gmail.com",
             school_id: "1",
             password: "lanhlala",
             password_confirmation: "lanhlala",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             school_id: "1",
             password: "lanhlala",
             password_confirmation: "lanhlala",
             activated: true,
             activated_at: Time.zone.now)

50.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "lanhlala"
  User.create!(name:  name,
               email: email,
               school_id: "1",
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end
