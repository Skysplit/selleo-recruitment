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

  describe "age between 20 and 30 scope" do
    it "should fetch users with age between 20 and 30 years" do
      [20, 30].each_with_index do |age, i|
        User.create email: "test#{i}@example.com", age: age
      end

      expect(User.age_between_20_and_30.count).to eq 2
    end
    
    it "should not fetch users with age below 20 and above 30" do
      [19, 31].each_with_index do |age, i|
        User.create email: "test#{i}@example.com", age: age
      end
      expect(User.age_between_20_and_30.count).to eq 0
    end
  end

  describe "interests relation" do
    it "should allow to have many interets" do
      user = User.create email: 'test@example.com', password: 'test'
      expect(user.valid?).to eq true
      fishing = user.interests.create name: 'test', category: :health
      kayaking = user.interests.create name: 'kayaking', category: :health
      expect(user.interests).to eq [fishing, kayaking]
    end
  end
end
