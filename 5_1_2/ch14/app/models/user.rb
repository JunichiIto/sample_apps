class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships,
        class_name: 'Relationship',
       foreign_key: :follower_id,
         dependent: :destroy
  has_many :passive_relationships,
        class_name: 'Relationship',
       foreign_key: :followed_id,
         dependent: :destroy
  # @user.active_relationships.map(&:followed)
  # @user.following
  has_many :following,
    through: 'active_relationships',
     source: 'followed'
  has_many :followers,
    through: 'passive_relationships',
     source: 'follower'

  # attr_accessorはRuby標準のメソッド(7.3.3)
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest


  validates :name,  presence: true, length: { maximum:  50 }
  # 定数の定義(7.3.5)
  # 正規表現リテラルとiオプション(6.3, 6.5.3)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, 
    length: { minimum: 6 }, allow_nil: true

  # クラスメソッドの定義（def self.xxxを使わないパターン）(7.3.4, 7.10.8)
  def User.digest(string)
    # 二重コロンを使った定数参照(7.8)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    # セッターメソッドの呼び出し（selfを付け忘れるとローカル変数への代入になる）(7.5.1)
    self.remember_token = User.new_token
    # こっちのselfは省略可能(7.5)
    self.update_attribute(:remember_digest,
      User.digest(remember_token))
  end
  
  def forget
    self.update_attribute(:remember_digest, nil)
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    # sendメソッドの利用(12.6)
    digest = self.send("#{attribute}_digest")
    # returnを使って途中でメソッドを抜ける(2.6.1)
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    # 自分自身（Userクラスのインスタンス）を引数として渡す(7.5)
    UserMailer.account_activation(self).deliver_now
  end
  
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    # hoursメソッドはRailsの独自拡張(A.2)
    reset_sent_at < 2.hours.ago
  end
  
  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  # current_user.feed
  # current_user.id
  # current_user.microposts
  def feed
    # 文字列リテラルは改行可能。代わりにヒアドキュメントを使ってもよい(2.8.3)
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id",
                                 user_id: self.id)
  end

  def follow(other_user)
    self.active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    self.active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    self.following.include?(other_user)
  end

  private
  
    def downcase_email
      self.email = self.email.downcase
    end
    
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(self.activation_token)
      # @user.activation_digest => ハッシュ値
    end
end
