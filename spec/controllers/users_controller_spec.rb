require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    context "when user is signed out" do
      it "should redirect to login page" do
        get :index
        expect(response).to redirect_to controller: 'devise/sessions', action: 'new'
      end
    end

    context "when user is signed in" do
      before(:each) do
        @jon = User.create email: 'jon@example.com', password: 'test'
        @jane = User.create email: 'jane@example.com', password: 'test'
      end

      it "should show users listing" do
        sign_in @jon
        get :index
        expect(assigns :users).to eq [@jon, @jane]
        expect(response).to render_template :index
      end
    end
  end
end
