class User < ApplicationRecord
    before_save {self.email = email.downcase}       #before_saveコールバックで保存する前にemailを小文字変換
    validates :name, presence: true, length: {maximum: 50}     #validates(:name, presence: true)と同義. validatesメソッドにpresence:trueという引数を与えている
    VALID_EMAIL_REGEX =/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 255},
                format: {with: VALID_EMAIL_REGEX},
                uniqueness: { case_sensitive: false }     #case_sensitiveで大文字小文字を区別可能になる。
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }
    
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
end
