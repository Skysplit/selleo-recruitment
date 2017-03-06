require 'rails_helper'

RSpec.describe Admin::HomeController, type: :controller do
  describe "GET #index" do
    context "when user is signed out" do
      it "should redirect to login page" do
        get :index
        expect(response).to redirect_to controller: 'devise/sessions', action: 'new'
      end
    end

    context "when normal user is logged in" do
      it "should redirect to root url" do
        user = User.create email: 'test@example.com', password: 'test'
        sign_in user
        get :index
        expect(response).to redirect_to root_url
        expect(flash[:alert]).to eq 'Thou shalt not pass!'
      end
    end

    context "when admin user is logged in" do
      it "should show admin page" do
        user = User.create email: 'test@example.com', password: 'test', admin: 1
        sign_in user
        get :index
        expect(response.status).to eq 200
        expect(response).to render_template 'index'
      end
    end
  end
end
