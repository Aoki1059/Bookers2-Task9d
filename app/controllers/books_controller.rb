class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only:[:edit,:update,:destroy]

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    # コメント投稿のインスタンス変数を
    @book_comment = BookComment.new
  end

  def index
    @books = Book.all
    @book = Book.new
     # Time.current(現在日時の取得)
    # beginning_of_week週初めの情報(https://railsdoc.com/page/date_related)
    # from = Time.current.beginning_of_week
    # # end_of_week週終わりの情報
    # to = Time.current.end_of_week
    # これにcreated_atを足したい
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort {|a,b|
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
      }
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
    sort_by {|x|
    x.favorited_users.includes(:favorites).where(created_at: from...to).size
    }.reverse
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title,:body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless  @book.user == current_user
      redirect_to books_path
    end
  end
end
