# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    height { 200 }
    width { 200 }
    content { Rack::Test::UploadedFile.new(Rails.root.join('test/support/images/screenshot.png'), 'image/png') }
  end
end