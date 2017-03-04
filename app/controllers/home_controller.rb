class HomeController < ApplicationController
  def index
    redirect_to user_signed_in? ? users_url : new_user_session_url
  end
end
