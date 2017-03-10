class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_user, only: [:destroy]
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to users_url, alert: exception.message
  end

  def index
    @q = User.ransack(search_params[:q])
    @users = @q.result.listing.includes(:interests)

    respond_to do |format|
      format.html
      format.csv do
        authorize! :admin, User
        headers = ['id', 'email', 'gender', 'age']
        values = @users.map { |user| user.slice(*headers).values }
        send_data CsvHelper.create_csv_string(headers: headers, values: values),
          filename: 'users.csv',
          type: 'text/csv'
      end
    end
  end

  def destroy
    authorize! :destroy, @user, message: 'You are not allowed to delete users or deleting yourself.'
    @user.destroy
    redirect_to users_url, notice: "Successfully deleted user #{@user.email}"
  end

  def send_regards
    user = User.find(params[:id])
    SendRegardsService.new(UserMailer, current_user, user).call
    redirect_to users_url, notice: "User #{user.email} received your regards."
  end

  private

  def get_user
    @user = User.find(params[:id])
  end

  def search_params
    params.permit(q: [:email_cont, :s])
  end
end
