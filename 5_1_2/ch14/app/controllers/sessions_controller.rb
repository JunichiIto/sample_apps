class SessionsController < ApplicationController

  # GET /login
  def new
    #@session = Session.new
  end
  
  # POST /login 
  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        # Success
        log_in user
        # 三項演算子(2.10.5)
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        # +=を使った文字列の連結(4.6.2)
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # Failure
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  # DELETE /logout
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
