class Admin::ApplicationController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!, :check_admin_access
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to users_url, alert: 'Thou shalt not pass!'
  end

  private

  def check_admin_access
    authorize! :admin, User
  end
end
