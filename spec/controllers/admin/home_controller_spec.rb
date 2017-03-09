require 'rails_helper'

RSpec.describe Admin::HomeController, type: :controller do
  describe "GET #index" do
    context "when user is signed out" do
      it "should redirect to login page" do
        get :index
        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when normal user is signed in" do
      it "should redirect to users url" do
        user = User.create email: 'test@example.com', password: 'test'
        sign_in user
        get :index
        expect(response).to redirect_to users_url
        expect(flash[:alert]).to eq 'Thou shalt not pass!'
      end
    end

    context "when admin user is signed in" do
      before :each do
        @admin = User.create email: 'admin@example.com', password: 'test', admin: true
        sign_in @admin
      end

      it "should show admin page" do
        get :index
        expect(response.status).to eq 200
        expect(response).to render_template :index
      end

      it "should get count of interests in health category that start with 'cosm' and belong to women aged between 20 and 30" do
        get :index
        expect(assigns :count).to eq 0
      end
    end
  end
end
