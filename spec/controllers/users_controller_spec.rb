require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    context "when user is signed out" do
      it "should redirect to login page" do
        get :index
        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when normal user is signed in" do
      before :each do
        @jon = User.create email: 'jon@example.com', age: 22
        sign_in @jon
      end

      it "should show users listing" do
        jane = User.create email: 'jane@example.com'
        get :index
        expect(assigns :users).to eq [@jon, jane]
        expect(response).to render_template :index
      end

      it "should properly fetch interests" do
        fishing = @jon.interests.create name: 'fishing'
        kayaking = @jon.interests.create name: 'kayaking'
        get :index
        users = assigns :users
        expect(users).to eq [@jon]
        expect(users.first.interests).to eq [fishing, kayaking]
      end

      it "should redirect to users listing when format: csv" do
        get :index, params: { format: :csv }
        expect(response).to redirect_to users_url
      end
    end

    context "when admin user is signed in" do
      it "should download csv file" do
        user = User.create email: 'test@example.com', age: 41, gender: :female, admin: 1
        sign_in user
        get :index, params: { format: :csv }
        expect(response.headers).to have_key 'Content-Type'
        expect(response.headers).to have_key 'Content-Disposition'
        expect(response.headers['Content-Type']).to include 'text/csv'
        expect(response.body).to include user.email
        expect(response.body).to include user.age.to_s
        expect(response.body).to include user.gender
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

  describe "POST #send_regards" do
    context "when user is signed out" do
      it "should redirect to login page" do
        delete :send_regards, params: { id: 1 }
        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when user is signed in" do
      before :each do
        @jon = User.create email: 'jon@example.com'
        @jane = User.create email: 'jane@example.com'
        sign_in @jon
      end

      it "should use SendRegardsService when sending email" do
        expect_any_instance_of(SendRegardsService).to receive(:call)
        post :send_regards, params: { id: @jane.id }
      end

      it "should send email to user" do
        deliveries = ActionMailer::Base.deliveries
        expect {
          post :send_regards, params: { id: @jane.id }
        }.to change(deliveries, :count).by(1)
        expect(deliveries.last['from'].to_s).to eq @jon.email
        expect(deliveries.last['to'].to_s).to eq @jane.email
      end

      it "should redirect after email was sent" do
        post :send_regards, params: { id: @jane.id }
        expect(response).to redirect_to users_url
        expect(flash[:notice]).to eq "User #{@jane.email} received your regards."
      end
    end
  end
end
