require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  before :each do
    @admin = User.create email: 'admin@example.com', password: 'test', admin: true
  end

  describe "GET #index" do
    context "when user is signed out" do
      it "should redirect to login page" do
        get :index
        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when normal user is signed in" do
      it "should redirect to users listing" do
        user = User.create email: 'test@example.com'
        sign_in user
        get :index
        expect(response).to redirect_to users_url
        expect(flash[:alert]).to eq 'Thou shalt not pass!'
      end
    end

    context "when admin user is sign in" do
      it "should show users listing" do
        jane = User.create email: 'jane@example.com'
        sign_in @admin
        get :index
        expect(response).to render_template 'index'
        expect(assigns :users).to eq [@admin, jane]
      end
    end
  end

  describe "GET #new" do
    context "when user is signed out" do
      it "should redirect to login page" do
        get :new
        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when normal user is signed in" do
      it "should redirect to users listing" do
        user = User.create email: 'test@example.com'
        sign_in user
        get :new
        expect(response).to redirect_to users_url
        expect(flash[:alert]).to eq 'Thou shalt not pass!'
      end
    end

    context "when admin user is sign in" do
      it "should show user form" do
        sign_in @admin
        get :new
        expect(response).to render_template :new
        expect(assigns :user).to be_kind_of User
      end
    end
  end

  describe "GET #edit" do
    context "when user is signed out" do
      it "should redirect to login page" do
        get :edit, params: { id: @admin.id }
        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when normal user is signed in" do
      it "should redirect to users listing" do
        user = User.create email: 'test@example.com'
        sign_in user
        get :edit, params: { id: @admin.id }
        expect(response).to redirect_to users_url
        expect(flash[:alert]).to eq 'Thou shalt not pass!'
      end
    end

    context "when admin user is singed in" do
      it "should show user form" do
        sign_in @admin
        get :edit, params: { id: @admin.id }
        expect(assigns :user).to eq @admin
      end
    end
  end

  describe "POST #create" do
    context "when user is signed out" do
      it "should redirect to login page" do
        post :create, params: { id: @admin.id }
        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when normal user is signed in" do
      it "should redirect to users listing" do
        user = User.create email: 'test@example.com'
        sign_in user
        post :create, params: { id: @admin.id }
        expect(response).to redirect_to users_url
        expect(flash[:alert]).to eq 'Thou shalt not pass!'
      end
    end

    context "when admin user is signed in" do
      before :each do
        sign_in @admin
      end

      it "should raise ActionController::ParameterMissing exception" do
        expect { post :create }.to raise_error ActionController::ParameterMissing
      end

      it "should create new user" do
        expect {
          post :create, params: { user: { email: 'test@example.com', gender: 'male'} }
        }.to change(User, :count).by 1
      end

      it "should create new interest" do
        expect {
          post :create, params: { user: { email: 'test@example.com', gender: 'male',
            interests_attributes: [ { name: 'test', category: 'health' } ] } }
        }.to change(Interest, :count).by 1
      end

      it "should redirect to users listing" do
        post :create, params: { user: { email: 'test@example.com', gender: 'male'} }
        expect(response).to redirect_to action: :index
        expect(flash[:notice]).to be_present
      end

      it "should render new template with invalid user" do
        post :create, params: { user: { email: 'test', gender: 'male'} }
        expect(response).to render_template :new
        expect((assigns :user).errors).to have_key :email
      end

      it "should render new template with invalid interest" do
        post :create, params: { user: { email: 'test@example.com', gender: 'male',
          interests_attributes: [ { name: '', category: 'health' } ] } }
        expect(response).to render_template :new
        expect((assigns :user).errors).to have_key :'interests.name'
      end
    end
  end

  describe "PUT #update" do
    context "when user is signed out" do
      it "should redirect to login page" do
        put :update, params: { id: @admin.id }
        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when normal user is signed in" do
      it "should redirect to users listing" do
        user = User.create email: 'test@example.com'
        sign_in user
        put :update, params: { id: @admin.id }
        expect(response).to redirect_to users_url
        expect(flash[:alert]).to eq 'Thou shalt not pass!'
      end
    end

    context "when admin user is signed in" do
      before :each do
        sign_in @admin
      end

      it "should update existing user" do
        put :update, params: { id: @admin.id, user: { email: 'test_admin@example.com', gender: 'female' } }
        @admin.reload
        expect(@admin.email).to eq 'test_admin@example.com'
        expect(@admin.gender).to eq 'female'
        expect(response).to redirect_to action: :index
        expect(flash[:notice]).to be_present
      end

      it "should render edit template" do
        put :update, params: { id: @admin.id, user: { email: 'test', gender: 'other' } }
        expect(response).to render_template :edit
        expect((assigns :user).errors).to have_key :email
      end
    end
  end
end
