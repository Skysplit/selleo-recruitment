class User < ApplicationRecord
  devise :database_authenticatable

  enum gender: [:other, :male, :female]

  has_many :interests, dependent: :delete_all
  accepts_nested_attributes_for :interests, allow_destroy: true

  validates :email, presence: true, email: true, uniqueness: true
  validates :gender, presence: true, inclusion: { in: self.genders.keys }
  validates :age, numericality: { greather_than: 0, allow_nil: true }
end
