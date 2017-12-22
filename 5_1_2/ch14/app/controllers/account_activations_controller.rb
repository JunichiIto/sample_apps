# クラスの継承(7.6.4)
class AccountActivationsController < ApplicationController
  def edit
    # クラスメソッドの呼び出し(7.3.4)
    # キーワード引数(5.4.3)
    user = User.find_by(email: params[:email])
    # ?で終わるメソッド(2.11.2)
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # Success => Signup
      user.activate
      # ()のないメソッド呼び出し(2.2.2)
      log_in user
      # ハッシュの更新(5.2.1)
      flash[:success] = "Account activated!"
      redirect_to user
    else
      # Failure
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
