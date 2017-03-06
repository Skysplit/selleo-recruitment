class User < ApplicationRecord
  devise :database_authenticatable
  enum gender: [:other, :male, :female]
  has_many :interests
end
