class Admin::ApplicationController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!, :check_admin_access

  private

  def check_admin_access
    redirect_to root_url, alert: 'Thou shalt not pass!' unless current_user.admin?
  end
end
