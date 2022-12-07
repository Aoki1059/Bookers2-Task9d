class BookCommentsController < ApplicationController

   #止めたいときは下のを使う
    #binding.pry

  def create
    # 非同期化の為、インスタンス変数に変更
    @book = Book.find(params[:book_id])
    @book_comment = current_user.book_comments.new(book_comment_params)
    # ↑上記のコードは省略記述
    @book_comment.book_id = @book.id
    @book_comment.save
    # books_controllerのshowと同じ値を渡す
    @book_comment = BookComment.new
    # １つ前の画面に
    # redirect_to request.referer
  end

  def destroy
    BookComment.find(params[:id]).destroy
    # renderしたときに@bookのデータが無い為@bookを定義
    @book = Book.find(params[:book_id])
    # 投稿が残らないようにするために下を記述
    @book_comment = BookComment.new
    # １つ前の画面に戻る
    # redirect_to request.referer
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
