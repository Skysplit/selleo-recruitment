require 'rails_helper'
require 'capybara/rspec'

feature 'User listing', type: :feature do
  let(:user) { User.create email: 'test@example.com', age: 22, gender: :female }
  let(:admin) { User.create email: 'admin@example.com', age: 40, gender: :male, admin: true }

  scenario "Filters out user that does not contain string" do
    login_as user
    visit users_path
    fill_in 'Email contains', with: 'lorem'
    click_button 'Search'

    expect(find 'table > tbody').not_to have_content user.email
  end

  scenario "Does not filter out user that does contain string" do
    login_as user
    visit users_path
    fill_in 'Email contains', with: 'test'
    click_button 'Search'

    expect(find 'table > tbody').to have_content user.email
  end

  scenario "Does not show admin panel link for user" do
    login_as user
    visit users_path
    expect(page).not_to have_content 'Admin panel'
  end

  scenario "Does show admin panel link for admin" do
    login_as admin
    visit users_path
    expect(page).to have_content 'Admin panel'
  end

  scenario "Does not show admin trash icon for admin" do
    login_as admin
    visit users_path
    expect(page).to have_no_css 'a.btn.btn-danger > i.fa.fa-trash'
  end

  scenario "Shows user trash icon for admin" do
    login_as admin
    user
    visit users_path
    expect(page).to have_css 'tbody > tr:nth-child(2) > td > a.btn.btn-danger > i.fa.fa-trash'
  end
end
