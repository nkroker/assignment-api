class UserAuthenticationController < ApplicationController

  def register
    user = User.new(user_params)

    if user.save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: login_params[:email])
    if user && user.authenticate(login_params[:password])
      token = JsonWebToken.encode(login_params)
      render json: {token: token}, status: :ok
    else
      render json: { error: 'not_found' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def register_params
    params.pernit(:name, :email, :password, :role)
  end
end
