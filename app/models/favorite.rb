class Favorite < ApplicationRecord
  # UserモデルとのN:1の関係付け
  belongs_to :user
  # BookモデルとのN:1の関係付け
  belongs_to :book
  # １ユーザーが、１つの本に対して１つのいいねしかできなくする
  validates_uniqueness_of :book_id, scope: :user_id
end
