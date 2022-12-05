class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @text = params[:word]
    # コードが受け取っている情報
    # 検索モデル→params[:range],検索手法→params[:search],検索ワード→params[:word]
    @range = params[:range]
    # 検索モデルUser or Bookの条件分岐
    # looksメソッドを使い、検索内容を取得、変数に代入
    # 検索方法params[:search]と、検索ワードparams[:word]を参照してデータを検索し、
    # 1：インスタンス変数@usersにUserモデル内での検索結果を代入する。
    # 2：インスタンス変数@booksにBookモデル内での検索結果を代入する。
    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    else
      @books = Book.looks(params[:search], params[:word])
    end
  end
end
