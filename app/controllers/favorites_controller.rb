class FavoritesController < ApplicationController
  def create
    # 非同期処理する際は、インスタンス変数に置き換える
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save
    # 非同期処理:リダイレクトをコメントアウトするとリダイレクト先がない、かつJavaScriptリクエストという状況になる
    # createアクション実行後は、create.js.erbファイルを探す
    # redirect_to request.referer
  end

  def destroy
    # 非同期処理する際は、インスタンス変数に置き換える
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy
    # 非同期処理:リダイレクトをコメントアウトするとリダイレクト先がない、かつJavaScriptリクエストという状況になる
    # destroyアクション実行後は、destroy.js.erbファイルを探す
    # redirect_to request.referer
  end
end
