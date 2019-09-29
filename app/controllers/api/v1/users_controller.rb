# frozen_string_literal: true
class Api::V1::UsersController < Api::ApiController
  before_action except: %i[sign_in sign_up] do
    doorkeeper_authorize!
  end

  def me
    @user = current_resource_owner
  end

  def sign_in
    @user = User.find_for_database_authentication(email: params.require(:email))

    return render json: { email: { not_found: I18n.t('.devise.failure.not_found_in_database', authentication_keys: 'Email') } }, status: 404 if @user.nil?

    if @user.valid_password?(params[:password])
      @access_token = Doorkeeper::AccessToken.create!(application_id: application.id, resource_owner_id: @user.id)
      return render 'api/v1/users/create'
    end

    render json: { credentials: { invalid: "Incorrect email or password" } }, status: 422
  end

  def sign_up
    @user = User.new (user_params)
    @app = check_app

    if @user.save
      @access_token = @user.create_token(@app.try(:id))
      return render 'api/v1/users/create'
    end
    respond_with @user
  end

  private

  def check_app
    return render json: {application: { invalid: "required client id and secret" } }, status: :not_found unless params['client_id'].present? && params['client_secret'].present?
    @app = Doorkeeper::Application.find_by({:uid => params['client_id'], :secret => params['client_secret']})
    return render json: {application: { invalid: "api not fount" } }, status: :not_found if @app.nil?
    @app
  end

  def user_params
    params.permit(:email, :name, :password)
  end
end
