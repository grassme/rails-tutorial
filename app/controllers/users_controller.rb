class UsersController < ApplicationController
  attr_reader :user

  def new
    @user = User.new
  end

  def create
    current_user = get_school.users.build user_params
    user = current_user

    if user.save
      flash[:success] = t "message.welcome"
      redirect_to user
    else
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]

    return if user
    flash[:danger] = t "layouts.application.error"
    redirect_to root_path
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
end
