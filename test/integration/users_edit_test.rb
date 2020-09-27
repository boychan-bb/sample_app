require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
def setup
  @user = users(:michael)
end

test "unsuccessful edit" do
  log_in_as(@user)
  get edit_user_path(@user)   #userの編集ページへアクセス
  assert_template "users/edit"    #edit.html.erbページが描画されたか
  patch user_path(@user), params: {user: {name:"", email: "foo@invalid", password: "foo", password_confirmation: "bar"}}    #patchメソッドで無効な情報を送信
  assert_template "users/edit"    #editページが再レダリングしていることを確認
end

test "successful edit" do
  log_in_as(@user)
  get edit_user_path(@user)   #userページを表示
  assert_template "users/edit"    #editページを描画したことを確認
  name = "Foo Bar"    #nameにFoo Barを代入
  email = "foo@bar.com"   #emailにfoo@bar.comを代入
  patch user_path(@user), params: {user: {name: name, email: email, password: "", password_confirmation:""}}    #passwordとpassword_comfirmationを空にする。
  assert_not flash.empty?   #フラッシュメッセージがからでないことを確認
  assert_redirected_to @user    #userページにリダイレクト
  @user.reload    #reloadを用いて、DBから最新のuser情報を読み直して、正しく更新されたかどうか確認
  assert_equal name, @user.name
  assert_equal email, @user.email
end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    patch user_path(@user), params: {user: {name: @user.name, email: @user.email }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end