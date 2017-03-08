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

  describe "name starts with cosm scope" do
    it "should fetch interests with name that starts with 'cosm'" do
      a = Interest.create name: 'cosmetics'
      b = Interest.create name: 'cosmology'
      Interest.create name: 'military'
      Interest.create name: 'not cosmetics'

      expect(Interest.name_starts_with_cosm.count).to eq 2
      expect(Interest.name_starts_with_cosm).to eq [a, b]
    end
  end

  describe "belongs to women between 20 and 30 scope" do
    it "should fetch interest that belong to women with age between 20 and 30" do
      u = User.create email: 'a@example.com', gender: :female, age: 20, interests_attributes: [
        { name: 'test1' }
      ]
      User.create email: 'b@example.com', gender: :male, age: 20, interests_attributes: [
        { name: 'test2' }
      ]
      User.create email: 'c@example.com', gender: :female, age: 31, interests_attributes: [
        { name: 'test3' }
      ]

      expect(Interest.belongs_to_women_between_20_and_30.count).to eq 1
      expect(Interest.belongs_to_women_between_20_and_30).to eq u.interests
    end
  end
end
