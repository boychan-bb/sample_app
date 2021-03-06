require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: {session: {email: @user.email, password: "password"}}
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!    #実際に上のコードでリダイレクトされたページに移動する処理
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count:0    #ログイン用リンクが表示されなくなったことを確認
    assert_select "a[href=?]", logout_path    #logout用リンクが表示されるようになったことを確認
    assert_select "a[href=?]", user_path(@user)   #userのマイページリンクが表示されるようになったことを確認
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    delete logout_path    #２番目のウィンドウでログアウトをクリックするuserをシュミレートする
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end