# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :google_oauth2

  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      # Generate JWT token for the user
      token = Warden::JWTAuth::UserEncoder.new.call(@user, :user, nil).first
      
      render json: {
        code: 200,
        message: 'Logged in successfully with Google.',
        data: {
          user: UserSerializer.new(@user).serializable_hash[:data][:attributes],
          token: token
        }
      }, status: :ok
    else
      render json: {
        code: 422,
        message: 'Authentication failed.',
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def failure
    render json: {
      code: 422,
      message: 'Authentication failed.',
      error: params[:message]
    }, status: :unprocessable_entity
  end
end
