class BookCommentsController < ApplicationController

  def create
    book = Book.find(params[:book_id])
    book_comment = current_user.book_comments.new(book_comment_params)
    # ↑上記のコードは省略記述
    book_comment.book_id = book.id
    book_comment.save
    # １つ前の画面に
    redirect_to request.referer
    # redirect_to book_path(book)
  end

  def destroy
    BookComment.find(params[:id]).destroy
    # １つ前の画面に戻る
    redirect_to request.referer
    # redirect_to book_path(params[:book_id])
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
