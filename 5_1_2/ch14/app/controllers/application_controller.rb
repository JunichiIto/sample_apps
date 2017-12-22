# 二重コロンで名前空間を区切る(8.6.1)
class ApplicationController < ActionController::Base
  # クラス構文の直下でクラスメソッドを呼び出す(8.5.7)
  protect_from_forgery with: :exception
  # モジュールのinclude(8.3.1)
  include SessionsHelper  

  def hello
    render html: 'hello, world!'
  end

  # privateメソッドの定義(7.7.2)
  private
  
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
