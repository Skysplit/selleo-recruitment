class AddCategoryToInterests < ActiveRecord::Migration[5.0]
  def change
    add_column :interests, :category, :integer, null: false, default: 0
  end
end
