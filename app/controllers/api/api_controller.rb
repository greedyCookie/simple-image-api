# frozen_string_literal: true

class Api::ApiController < ActionController::Base
  skip_before_action :verify_authenticity_token

  respond_to :json

  protect_from_forgery with: :null_session

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

  def check_app
    return render json: {application: { invalid: "required client id and secret" } }, status: :not_found unless params['client_id'].present? && params['client_secret'].present?
    @app = Doorkeeper::Application.find_by({:uid => params['client_id'], :secret => params['client_secret']})
    return render json: {application: { invalid: "api not fount" } }, status: :not_found if @app.nil?
    @app
  end
end