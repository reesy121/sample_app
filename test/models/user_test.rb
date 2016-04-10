require 'test_helper'

class UserTest < ActiveSupport::TestCase
	def setup
		@user = User.new(name: "Example User", email: "user@example.com",
						password: "foobar", password_confirmation: "foobar")
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "name should be present" do
		@user.name = "    "
		assert_not @user.valid?
	end

	test "email should be present" do
		@user.email = "    "
		assert_not @user.valid?
	end

	test "name should not be too long" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "email should not be too long" do
		@user.email = "a" * 256
		assert_not @user.valid?
	end

	test "email validation should accept valid addresses" do
		valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.o
							first.last@foo.jp alice+bob@baz.cn]
		valid_addresses.each do |email|
			@user.email = email
			assert @user.valid?, "Address #{valid_addresses.inspect} should be valid"
		end
	end

	test "email validation should reject invalid addresses" do
		invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
								foo@bar_baz.com foo@bar+baz.com]
		invalid_addresses.each do |email|
			@user.email = email
			assert_not @user.valid?, "Address #{invalid_addresses.inspect} should be invalid"
		end
	end

	test "email address should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	test "password should have minimum length" do
		@user.password = @user.password_confirmation =  "a" * 5
		assert_not @user.valid?
	end

	test "authenicated? should return false for a user with nil digest" do
		assert_not @user.authenticated?(:remember, '')
	end

	test "should follow and unfollow a user" do
		david = users(:david)
		rees = users(:rees)
		assert_not david.following?(rees)
		david.follow(rees)
		assert david.following?(rees)
		assert rees.followers.include?(david)
		david.unfollows(rees)
		assert_not david.following?(rees)
	end

	test "feed shoud have the right posts" do
		david  = users(:david)
		archer = users(:archer)
		lana   = users(:lana)
		# Posts from followed user
		lana.microposts do |post_following|
			assert david.feed.include?(post_following)
		end 
		# Posts from self
		david.microposts do |post_self|
			assert david.feed.include?(post_self)
		end
		# Posts from unfollowed user
		archer.microposts.each do |post_unfollowed|
			assert_not lana.feed.include?(post_unfollowed)
		end
	end
end
