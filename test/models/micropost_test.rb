require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
  	@user = users(:david)
  	@micropost = @user.microposts.build(content: "doo doo dee dee")
  end

  test "should be valid" do
  	assert @micropost.valid?
  end

  test "user id should be present" do
  	@micropost.user_id = nil
  	assert_not @micropost.valid?
  end

  test "content should be present" do
  	@micropost.content = "     "
  	assert_not @micropost.valid?
  end

   test "content should be at most 140 characters" do
  	@micropost.content = "a" * 141
  	assert_not @micropost.valid?
  end

  test "order should be most recent first" do
  	assert_equal Micropost.first, microposts(:most_recent)
  end

  test "associated microposts should be destroyed" do
  	@user.save
  	@user.microposts.create!(content: "Lorem ipsum")
  	assert_difference 'Micropost.count', -(@user.microposts.count) do
  		@user.destroy
  	end
  end

end
