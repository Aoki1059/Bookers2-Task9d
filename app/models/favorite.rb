class Favorite < ApplicationRecord
  # UserモデルとのN:1の関係付け
  belongs_to :user
  # BookモデルとのN:1の関係付け
  belongs_to :book
end
