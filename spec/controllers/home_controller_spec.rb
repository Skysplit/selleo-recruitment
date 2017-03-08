require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    context "when user is signed out" do
      it "should redirect to login page" do
        get :index
        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when normal user is signed in" do
      it "should redirect to users page" do
        user = User.create email: 'test@example.com', password: 'test'
        sign_in user
        get :index
        expect(response).to redirect_to users_url
      end
    end
  end
end
