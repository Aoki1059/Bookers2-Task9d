class RelationshipsController < ApplicationController
  
  # フォローアンフォロー処理
  def create
    # params[:user_id]これはリンクから送られてきたuser_idをparamsで受け取っている
    # 受け取った値をモデルのメソッドに渡している
    @user = User.find(params[:user_id])
    current_user.follow(params[:user_id])
    # フォロー通知機能
    @user.create_notification_follow!(current_user)
    redirect_to request.referer
  end
  
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end
  
  # フォロー・フォロワー一覧処理
  def followeings
    user = User.find(params[:user_id])
    @users = user.followeings
  end
  
  def followers
    user = User.find(params[:user_id])
    @user = user.followers
  end
end
