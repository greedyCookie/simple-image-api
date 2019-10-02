require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
  end

  test 'valid image' do
    create(:image, user: @user)
    assert_not_nil @user.images
  end

  test 'invalid height' do
    assert_raises"Height can't be blank" do
      @image = create(:image, height: nil, user: @user)
    end
  end

  test 'invalid width' do
    assert_raises"Width can't be blank" do
      @image = create(:image, width: nil, user: @user)
    end
  end

  test 'invalid content' do
    assert_raises"Content can't be blank" do
      @image = create(:image, content: nil, user: @user)
    end
  end
end
