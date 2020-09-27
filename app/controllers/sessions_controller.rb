class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
    else
      flash.now[:danger] = "Invalid email/password combination"
      render "new"
    end
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])   #userがDBにあり、かつ、認証に成功した場合のみ、つまりtrue&&trueの場合にtrueとなる
      log_in user   #log_inメソッドを引数userで呼び出し(Application ControllerでincludeSessionHelperで読み込んでいるので、そこにあるメソッドをsessionコントローラで使用可能)
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)   #三項演算子で"1"の時はremember(user),それ以外の時はforget(user)を実行
      redirect_to user    #userのプロフィールページへリダイレクト
    else
      flash.now[:danger] = "Invalid email/password combination"
      render "new"    #renderはリクエストとみなされないので、flash[:danger]だけだったら、リクエストとみなされず、flashメッセージが表示されたままになる
    end
  end
  
  def destroy
    log_out if logged_in?   #ログインしてれば、log_outメソッドを実行(ログイン中の場合のみログアウト実行する)
    redirect_to root_url
  end
  
end
