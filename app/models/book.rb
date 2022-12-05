class Book < ApplicationRecord
  # UserモデルとのN:1の関係付け
  belongs_to :user
  # BookCommentモデルとの1:Nの関係付け
  has_many :book_comments,dependent: :destroy
  # Favoriteモデルとの1:Nも関係付け
  has_many :favorites,dependent: :destroy
  # 引数で渡されたユーザidがFavoritesテーブルにあるか調べる
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
    # favorites.exists?(user_id: user.id)
  end
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  # 検索方法の分岐
  # titleは検索対象であるbooksテーブル内のカラム名
  def self.looks(search, word)
    if search == "perfect_match" #完全一致
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match" #前方一致
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match" #後方一致
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match" #部分一致
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
end
