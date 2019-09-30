# frozen_string_literal: true

class Api::V1::UsersController < Api::ApiController
  before_action except: %i[sign_in sign_up] do
    doorkeeper_authorize!
  end

  def me
    @user = current_resource_owner
  end

  #todo put errors to locale

  def sign_in
    @user = User.find_for_database_authentication(email: params[:email])
    app = check_app
    return render_error if @user.nil?

    if @user.valid_password?(params[:password])
      @access_token = @user.create_token(app.try(:id))
      return render 'api/v1/users/create', status: 201
    end

    render_error
  end

  def sign_up
    @user = User.new(user_params)
    app = check_app

    if @user.save
      @access_token = @user.create_token(app.try(:id))
      return render 'api/v1/users/create'
    end

    render_error
  end

  def sign_out
    if doorkeeper_token&.accessible?
      token = Doorkeeper::AccessToken.by_token(doorkeeper_token.token) || Doorkeeper::AccessToken.by_refresh_token(doorkeeper_token.token)

      token.revoke if token && doorkeeper_token.same_credential?(token)
    end

    head :ok
  end

  private

  def render_error
    render json: { credentials: { invalid: I18n.t('.devise.failure.not_found_in_database', authentication_keys: 'Email')} }, status: 422
  end

  def user_params
    params.permit(:email, :password)
  end
end
