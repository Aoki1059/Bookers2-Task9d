class ViewCount < ApplicationRecord
  # UserとBookモデルに対してN:1の関係を表す
  belongs_to :user
  belongs_to :book
end
