class Book < ApplicationRecord
  # UserモデルとのN:1の関係付け
  belongs_to :user
  # BookCommentモデルとの1:Nの関係付け
  has_many :book_comments,dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
end
