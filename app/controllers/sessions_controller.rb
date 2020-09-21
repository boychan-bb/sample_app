class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])   #userがDBにあり、かつ、認証に成功した場合のみ、つまりtrue&&trueの場合にtrueとなる
      log_in user   #log_inメソッドを引数userで呼び出し
      redirect_to user    #userのプロフィールページへリダイレクト
    else
      flash.now[:danger] = "Invalid email/password combination"
      render "new"    #renderはリクエストとみなされないので、flash[:danger]だけだったら、リクエストとみなされず、flashメッセージが表示されたままになる
  end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
  
end
