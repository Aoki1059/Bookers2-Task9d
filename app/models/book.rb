class Book < ApplicationRecord
  # UserモデルとのN:1の関係付け
  belongs_to :user
  
  # BookCommentモデルとの1:Nの関係付け
  has_many :book_comments,dependent: :destroy
  
  # Favoriteモデルとの1:Nも関係付け
  has_many :favorites,dependent: :destroy
  
  has_many :favorites, dependent: :destroy
  # favoritesモデルから、userモデルの情報を持ってくる！
  has_many :favorited_users, through: :favorites, source: :user
  
  # favoriteで使用するメソッドの定義
  # 引数で渡されたユーザidがFavoritesテーブルにあるか調べる
  def favorited_by?(user)
    # favoritesの中に .where(カラム名: '田中'のような条件).exists?があるか
    # つまりuser.id を参照してあればtrueを返す
    favorites.where(user_id: user.id).exists?
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
