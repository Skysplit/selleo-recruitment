require 'rails_helper'

RSpec.describe Interest, type: :model do
  describe "user relation" do
    it "should belong to user" do
      user = User.create email: 'test@example.com', password: 'test'
      interest = Interest.create name: 'test', user: user
      interest.reload
      expect(interest.user).to eq user
    end
  end
end
