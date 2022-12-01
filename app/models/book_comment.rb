class BookComment < ApplicationRecord
  # UserモデルとのN:1の関係付け
  belongs_to :user
  # BookモデルとのN:1の関係付け
  belongs_to :book
  # 空白データの保存禁止
  validates :comment, presence: true
end
