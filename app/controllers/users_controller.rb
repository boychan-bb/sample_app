class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user   #redirect_to user_url(@user)と等価
    else
      render "new"
    end
  end
  
  def edit
    #@user = User.find(params[:id])　左記コードはbefore_actionのcorrect_userで既に定義しているので、必要なし
  end
  
  def update
    @user = User.find(params[:id])    #左記コードはbeofre_actionのcorrect_userで既に定義しているので、必要なし
    if @user.update_attributes(user_params)   #ストロングパラメータを用いてマスアサイメントの脆弱性を防止している。
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def logged_in_user
      unless logged_in?
        store_location    #session helperに定義したstore_locationメソッドでaccessしようとしたページを保存
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)   #sessionsヘルパー内で定義したcurrent_user?メソッドを引数@userで呼び出し
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
