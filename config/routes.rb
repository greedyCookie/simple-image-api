# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # done without resources - to better understanding for developers

      get 'users/me' => 'users#me'
      post 'users/sign_in' => 'users#sign_in'
      post 'users/sign_up' => 'users#sign_up'
      delete 'users/sign_out' => 'users#sign_out'

      post 'images/create' => 'images#create'
      get 'images/index' => 'images#index'
      put 'images/update/:id' => 'images#update'
    end
  end
end

