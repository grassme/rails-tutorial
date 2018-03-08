class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  attr_reader :user

  def index
    @users = User.activated.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    user = get_school.users.build user_params
    if user.save
      user.send_activation_email
      flash[:info] = t "flash.info"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    redirect_to root_url unless user.activated?
  end

  def edit; end

  def update
    if user.update_attributes user_params
      flash[:success] = t "flash.success"
      redirect_to user
    else
      render :edit
    end
  end

  def destroy
    user.destroy
    flash[:success] = t "flash.destroy"
    redirect_to users_url
  end

  private

  def get_school
    school_name = params[:school][:name]
    school = School.find_by name: school_name

    school = School.create name: school_name unless school
    school
  end

  private

  def user_params
    params.require(:user).permit User::ATTR
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "flash.please_login"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if user
    flash[:danger] = t "layouts.application.error"
    redirect_to rool_url
  end
end
