require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid user' do
    assert_not_nil create(:user)
  end

  test 'invalid user email' do
    assert_raises "Email can't be blank" do
      create(:user, email: nil)
    end
  end

  test 'invalid user password' do
    assert_raises "Password can't be blank" do
      create(:user, password: nil)
    end
  end
end
