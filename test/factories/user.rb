# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'test@example.com' }
    password { '123456' }
  end

  factory :another_user, parent: :user do
    email { 'test1@example.com' }
    password { '123456' }
  end
end