class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Bookモデルとの1:Nの関係付け
  has_many :books
  # Userモデルとの1:Nの関係付け
  has_many :book_comments, dependent: :destroy
  # Favoriteモデルとの関係付け
  has_many :favorites,dependent: :destroy
  # フォロー機能のアソシエーション(follower_id:自分,followed_id:相手)
  # 自分がフォローしたり、アンフォローするための記述
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 相手が自分をフォロー、アンフォローするための記述
  has_many :reverse_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォロー一覧を表示するための記述
  has_many :followings, through: :relationships, source: :followed
  # フォロワー一覧を表示するための
  has_many :followers, through: :reverse_relationships, source: :follower
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}

  #フォローしたときの処理
  def follow(user_id)
    unless self == user_id
     self.relationships.find_or_create_by(followed_id: user_id.to_i, follower_id: self.id)
    end
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしているかの判定
  def following?(user)
    followings.include?(user)
  end
  # 検索方法の分岐
  # nameはusersテーブルのカラム名
  def self.looks(search, word)
   if search == "perfect_match" #完全一致
     @user = User.where("name LIKE?", "#{word}")
   elsif search == "forward_match" #前方一致
     @user = User.where("name LIKE?","#{word}%")
   elsif search == "backward_match" #後方一致
     @user = User.where("name LIKE?","%#{word}")
   elsif search == "partial_match" #部分一致
     @user = User.where("name LIKE?","%#{word}%")
   else
     @user = User.all
   end
  end


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
