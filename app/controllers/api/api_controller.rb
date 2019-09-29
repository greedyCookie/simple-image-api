# frozen_string_literal: true

class Api::ApiController < ActionController::Base
  skip_before_action :verify_authenticity_token

  respond_to :json

  protect_from_forgery with: :null_session

  rescue_from Exception, with: :handle_exception

  before_action :current_resource_owner


  def respond_with object
    if object.errors.present?
      errors = {}
      object.errors.details.each do |error, value|
        data = {}
        value.each_with_index do |detail, index|
          next if data[detail[:error]].present?
          data[detail[:error]] = "#{error} #{object.errors.messages[error][index]}"
        end
        errors[error] = data
      end
      return render json: errors, status: :unprocessable_entity
    end

    render json: object.to_json
  end

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_user
    current_resource_owner
  end
end