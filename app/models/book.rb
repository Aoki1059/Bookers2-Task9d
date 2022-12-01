class Book < ApplicationRecord
  # UserモデルとのN:1の関係付け
  belongs_to :user
  # BookCommentモデルとの1:Nの関係付け
  has_many :book_comments,dependent: :destroy
  # Favoriteモデルとの1:Nも関係付け
  has_many :favorites,dependent: :destroy
  # 引数で渡されたユーザidがFavoritesテーブルにあるか調べる
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
end
