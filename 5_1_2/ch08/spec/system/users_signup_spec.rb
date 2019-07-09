require "rails_helper"

RSpec.describe "Users signup", type: :system do
  example "valid signup information" do
    visit signup_path

    fill_in "Name", with: "Example User"
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password"
    fill_in "Confirmation", with: "password"

    expect {
      click_button "Create my account"
    }.to change(User, :count).by(1)

    user = User.last
    expect(current_path).to eq user_path(user)
    expect(page).to have_content "Welcome to the Sample App!"

    within '.navbar-nav' do
      expect(page).to_not have_content 'Log in'
      expect(page).to have_content 'Account'
    end
  end
end
