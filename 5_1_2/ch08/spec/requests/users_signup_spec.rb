require "rails_helper"

RSpec.describe "Users signup", type: :request do
  example "valid signup information" do
    get signup_path
    expect {
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    }.to change(User, :count).by(1)
    # redirect_to @user
    follow_redirect!
    # Test
    expect(response).to render_template('users/show')
    expect(is_logged_in?).to be_truthy
  end
end
