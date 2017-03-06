require 'rails_helper'

RSpec.describe User, type: :model do
  describe "gender" do
    def create_user(gender)
      User.create email: 'test@example.com', password: 'test', gender: gender
    end

    it "should create user with default gender" do
      user = User.create email: 'test@example.com', password: 'test'
      expect(user.gender).to eq 'other'
    end

    it "should create user with 'other' gender" do
      user = create_user 0
      expect(user.gender).to eq 'other'
    end

    it "should create user with 'male' gender" do
      user = create_user 1
      expect(user.gender).to eq 'male'
    end

    it "should create user with 'female' gender" do
      user = create_user 2
      expect(user.gender).to eq 'female'
    end
  end

  describe "interests relation" do
    it "should allow to have many interets" do
      user = User.create email: 'test@example.com', password: 'test'
      fishing = user.interests.create name: 'test'
      kayaking = user.interests.create name: 'kayaking'
      user.reload
      expect(user.interests).to eq [fishing, kayaking]
    end
  end
end
