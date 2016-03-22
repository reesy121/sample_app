User.create!(name: "Dave Rees",
			 email: "reesy121@hotmail.co.uk",
			 password: "ooohmelikey",
			 password_confirmation: "ooohmelikey",
			 admin:  true, )
99.times do |n|
 name = Faker::Name.name
 email = "example-#{n+1}@railstutorial.org"
 password = "ooohmelikey"
 User.create!(name: name,
			 email: email,
			 password: password,
			 password_confirmation: password)
end