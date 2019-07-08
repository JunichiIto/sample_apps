require "rails_helper"

RSpec.describe "Users signup", type: :request do
  def is_logged_in?
    !session[:user_id].nil?
  end

  example "valid signup information" do
    get signup_path
    expect {
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    }.to change(User, :count).by(1)
    redirect_to @user
    follow_redirect!
    # Test
    assert_template 'users/show'
    assert is_logged_in?
  end
end
