module SessionsHelper
    
    def log_in(user)        #渡されたuserでログインする
        session[:user_id] = user.id      #左記のコードでsessionメソッドで自動的に一時cookiesは暗号化される.一方、cookiesメソッドは保護されると断言不可能
    end
    
    def remember(user)
        user.remember       #model/user.rbファイル内のrememberメソッドを呼び出し
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end
    
    def current_user        #現在ログイン中のuserを返す(いる場合)
        if (user_id = session[:user_id])        #user_idと言う変数に、sessionの中のuser_idを代入した結果、userIDのセッションが存在すれば
            @current_user ||= User.find_by(id: user_id)     #||=(or equal)は左から右に評価して、最初にtrueになった時点で処理を終了する。find_byで見つけられなかったら単純にnilを返すだけ
        elsif (user_id = cookies.signed[:user_id])      #user_id変数にcookiesの中のuser_idを代入した結果、UserIDのクッキーがあれば
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end
    
    def logged_in?      #ログインしてればtrue,してなければfalseを返す
        !current_user.nil?      #current_userがnilの場合trueだが、!で否定しているので　falseを返す
    end
    
    def forget(user)        #永続セッションを破棄する
        user.forget         #userモデル内のforgetメソッドを呼び出して、remember_digestを削除なぜなら、remember_digestはmodelの中のDBに属性として存在しているから
        cookies.delete(:user_id)        #cookies内のuser_idを削除
        cookies.delete(:remember_token)     #remember_tokenを削除
    end
    
    def log_out     #ログアウト用のメソッド
        forget(current_user)    #上記に定義しているforgetメソッドを引数current_userで呼び出し、ただし、current_userメソッドを実行した戻り値を用いている
        session.delete(:user_id)        #sessionのidを削除
        @current_user = nil              #@current_userをnilにする
    end
end