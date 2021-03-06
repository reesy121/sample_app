# Creates Users
User.create!(name: "Dave Rees",
			 email: "reesy121@hotmail.co.uk",
			 password: "ooohmelikey",
			 password_confirmation: "ooohmelikey",
			 admin:  true, 
			 activated: true,
			 activated_at: Time.zone.now)
99.times do |n|
 name = Faker::Name.name
 email = "example-#{n+1}@railstutorial.org"
 password = "ooohmelikey"
 User.create!(name: name,
			 email: email,
			 password: password,
			 password_confirmation: password,
			 activated: true,
			 activated_at: Time.zone.now)
end

# Create Microposts
users = User.order(:created_at).first(6)
50.times do
	content = Faker::Lorem.sentence(5)
	users.each { |user| user.microposts.create!(content: content) }
end

# Create Following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
