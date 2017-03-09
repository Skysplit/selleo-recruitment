require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    context "when user is signed out" do
      it "should redirect to login page" do
        get :index
        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when user is signed in" do
      it "should show users listing" do
        jon = User.create email: 'jon@example.com'
        jane = User.create email: 'jane@example.com'
        sign_in jon
        get :index
        expect(assigns :users).to eq [jon, jane]
        expect(response).to render_template :index
      end

      it "should properly fetch interests" do
        jon = User.create email: 'jon@example.com'
        fishing = jon.interests.create name: 'fishing'
        kayaking = jon.interests.create name: 'kayaking'
        sign_in jon
        get :index
        users = assigns :users
        expect(users).to eq [jon]
        expect(users.first.interests).to eq [fishing, kayaking]
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is signed out" do
      it "should redirect to login page" do
        delete :destroy, params: { id: 1 }
        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when normal user is signed in" do
      it "should disallow deleting user" do
        jon = User.create email: 'jon@example.com'
        jane = User.create email: 'jane@example.com'
        sign_in jon
        delete :destroy, params: { id: jane.id }
        expect(response).to redirect_to action: 'index'
        expect(flash[:alert]).to eq 'You are not allowed to delete users or deleting yourself.'
      end
    end

    context "when admin user is signed in" do
      before :each do
        @admin = User.create email: 'admin@example.com', admin: true
        @jon = User.create email: 'jon@example.com'
        sign_in @admin
      end

      it "should allow to delete other user" do
        delete :destroy, params: { id: @jon.id }
        expect(response).to redirect_to action: 'index'
        expect(flash[:notice]).to eq "Successfully deleted user #{@jon.email}"
      end

      it "should not allow to delete himself" do
        delete :destroy, params: { id: @admin.id }
        expect(response).to redirect_to action: 'index'
        expect(flash[:alert]).to eq 'You are not allowed to delete users or deleting yourself.'
      end
    end
  end
end
