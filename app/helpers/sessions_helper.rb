module SessionsHelper
    
    def log_in(user)        #渡されたuserでログインする
        session[:user_id] = user.id      #sessionメソッドで自動的に一時cookiesは暗号化される
    end
    
    def current_user        #現在ログイン中のuserを返す(いる場合)
        if session[:user_id]        #もしsessionにuser_idがあれば以下の処理
            @current_user ||= User.find_by(id: session[:user_id])       #@current_userがnilの時だけ、右の式を実行する。
        end
    end
    
    def logged_in?      #ログインしてればtrue,してなければfalseを返す
        !current_user.nil?      #current_userがnilの場合trueだが、!で否定しているので　falseを返す
    end
    
    def log_out     #ログアウト用のメソッド
        session.delete(:user_id)        #sessionのidを削除
        @current_user = nil              #@current_userをnilにする
    end
end
