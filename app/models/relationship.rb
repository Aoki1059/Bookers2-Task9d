class Relationship < ApplicationRecord
  # userへのアソシエーション(follower,followed)
  # class_nameがuserテーブルを参照しにいってくれる
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end
