class User < ApplicationRecord
    attr_accessor :remember_token
    before_save {self.email = email.downcase}       #before_saveコールバックで保存する前にemailを小文字変換
    validates :name, presence: true, length: {maximum: 50}     #validates(:name, presence: true)と同義. validatesメソッドにpresence:trueという引数を与えている
    VALID_EMAIL_REGEX =/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 255},
                format: {with: VALID_EMAIL_REGEX},
                uniqueness: { case_sensitive: false }     #case_sensitiveで大文字小文字を区別可能になる。
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }
    
    def User.digest(string)     #渡された文字列のハッシュを返す
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    
    def User.new_token
        SecureRandom.urlsafe_base64     #６４種類の文字からなる長さ２２のランダムなトークンを返す
    end
    
    def remember        #永続セッションのためのuserをDBに記憶する
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    def authenticated?(remember_token)       #渡されたtokenがdigestと一致したらtrueを返す
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
    
    def forget      #userのログイン情報を破棄する
        update_attribute(:remember_digest, nil)     #remember_digest属性をnilで更新
    end
end
