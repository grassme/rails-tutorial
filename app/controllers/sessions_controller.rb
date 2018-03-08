class SessionsController < ApplicationController
  def new; end

  def create
    session = params[:session]
    user = User.find_by email: session[:email].downcase
    if user && user.authenticate(session[:password])
      if user.activated?
        login_success user
      else
        login_active
      end
    else
      login_fail
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def login_success user
    log_in user
    if params[:session][:remember_me] == Settings.rememeber_login
      remember user
    else
      forget user
    end
    redirect_back_or user
  end

  def login_fail
    flash.now[:danger] = t "error.login"
    render :new
  end

  def login_active
    flash[:warning] = t "flash.message"
    redirect_to root_url
  end
end
