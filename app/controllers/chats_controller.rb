class ChatsController < ApplicationController
  # showアクションを行う前に相互フォローかどうかを確認
  before_action :reject_non_related, only: [:show]
  def show
    # チャットする相手の情報
    @user = User.find(params[:id])
    # ログイン中のユーザーの部屋情報を取得
    rooms = current_user.user_rooms.pluck(:room_id)
    # その中にチャットする相手とのルームがあるか確認
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    # ユーザールームがなかったか確認
    unless user_rooms.nil?
      # あった場合、変数@roomにユーザー（自分と相手）と紐づいているroomを代入
      @room = user_rooms.room
    else　# ない場合
      @room = Room.new # 新しくroomを作成
      @room.save #roomを保存
      # 自分の中間テーブル作成
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      # 相手の中間テーブル作成
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    # チャットの一覧用の変数
    @chats = @room.chats
    # チャットの投稿用の変数
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    render :validater unless @chat.save
  end

  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  # 相互フォローかどうか確認する処理
  # unlessは「〜じゃなかった場合、trueで返して処理する」
  # 現在のユーザー（わたし）が対象のユーザー（あなた）をフォローしていてかつ、
  # 対象のユーザー（あなた）が現在のユーザー（わたし）をフォローしていなかった場合、
  # 一覧画面へリダイレクトさせるという記述
  def reject_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
  end
end
