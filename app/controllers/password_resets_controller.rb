class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)
  attr_reader :user

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    danger unless user
    send_mail user
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      user.errors.add :password, t("password.error")
      render :edit
    elsif user.update_attributes user_params
      reset_pass user
    else
      render :edit
    end
  end

  private

  def danger
    render :new
    flash.now[:danger] = t "flash.danger.email_notfound"
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]

    return if user
    flash[:error] = t "layouts.application.error"
    redirect_to rool_url
  end

  def valid_user
    return if user && user.activated? && user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless user.password_reset_expired?
    flash[:danger] = t "password.danger"
    redirect_to new_password_reset_url
  end

  def send_mail user
    user.create_reset_digest
    user.send_password_reset_email
    flash[:info] = t "password.info"
    redirect_to root_url
  end

  def reset_pass user
    log_in user
    user.update_attributes reset_digest: nil
    flash[:success] = t "password.success"
    redirect_to user
  end
end
