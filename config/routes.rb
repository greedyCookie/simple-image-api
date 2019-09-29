# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'users/me' => 'users#me'
      post 'users/sing_in' => 'users#sign_in'
      post 'users/sing_up' => 'users#sign_up'
    end
  end
end

