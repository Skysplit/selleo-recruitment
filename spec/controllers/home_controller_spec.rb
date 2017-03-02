require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    it "should redirect to login page" do
      get :index
      expect(response).to redirect_to controller: 'devise/sessions', action: 'new'
    end

    it "should redirect to users page" do
      user = User.create email: 'test@example.com', password: 'test'
      sign_in user
      get :index
      expect(response).to redirect_to controller: 'users', action: 'index'
    end
  end
end