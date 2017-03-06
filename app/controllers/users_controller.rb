class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user, only: [:destroy]
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to users_url, alert: exception.message
  end

  def index
    @users = User.includes(:interests).all
  end

  def destroy
    authorize! :destroy, @user, message: 'You are not allowed to delete users or deleting yourself.'
    @user.destroy
    redirect_to users_url, notice: "Successfully deleted user #{@user.email}"
  end

  private
  def get_user
    @user = User.find(params[:id])
  end
end
