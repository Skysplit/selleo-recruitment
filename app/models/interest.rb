class Interest < ApplicationRecord
  belongs_to :user
  enum category: [:health, :hobby, :work]

  validates :name, presence: true
  validates :category, inclusion: { in: self.categories.keys }, presence: true
end
