class Interest < ApplicationRecord
  belongs_to :user, inverse_of: :interests
  enum category: [:health, :hobby, :work]

  validates :name, presence: true
  validates :category, inclusion: { in: self.categories.keys }, presence: true

  scope :belongs_to_women_between_20_and_30, -> { where user_id: User.select(:id).female.age_between_20_and_30 }
  scope :name_starts_with_cosm, -> { where 'name LIKE :param', param: 'cosm%' }
end
