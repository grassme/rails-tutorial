class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      active_success user
    else
      flash[:danger] = t "flash.link_invalid"
      redirect_to root_url
    end
  end

  private

  def active_success user
    user.activate
    log_in user
    flash[:success] = t "flash.acc_activated"
    redirect_to user
  end
end
