class Book < ApplicationRecord
  # UserモデルとのN:1の関係付け
  belongs_to :user

  # BookCommentモデルとの1:Nの関係付け
  has_many :book_comments,dependent: :destroy

  has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'

  # 閲覧数表示 1:Nの関係
  has_many :view_counts, dependent: :destroy

  # Favoriteモデルとの1:Nも関係付け
  has_many :favorites, dependent: :destroy

  # favoritesモデルから、userモデルの情報を持ってくる！
  has_many :favorited_users, through: :favorites, source: :user

  # favoriteで使用するメソッドの定義
  # 引数で渡されたユーザidがFavoritesテーブルにあるか調べる
  # favoritesの中に .where(カラム名: '田中'のような条件).exists?があるか
  # つまりuser.id を参照してあればtrueを返す
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
  # レビュー機能
  # scope :latest, -> {order(created_at: :desc)}
  # order・・・データの取り出し Latest・・・任意の名前で定義する
  # order(created_at: :desc)
  # created_at・・・投稿日のカラム desc・・・昇順 asc・・・降順
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :star_count, -> {order(star: :desc)}

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
