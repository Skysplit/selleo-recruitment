class Admin::UsersController < Admin::ApplicationController
  before_action :get_user, only: [:edit, :update]

  def index
    @users = User.includes(:interests).all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_url, notice: "Successfully created user #{@user.email}"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_url, notice: "Successfully updated user #{@user.email}"
    else
      render 'edit'
    end
  end


  private

  def get_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit :email, :age, :gender, interests_attributes: [:id, :name, :type, :_destroy]
  end
end
