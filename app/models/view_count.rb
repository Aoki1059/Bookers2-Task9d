class ViewCount < ApplicationRecord
  # UserとBookモデルに対してN:1の関係
  belongs_to :user
  belongs_to :book
end
