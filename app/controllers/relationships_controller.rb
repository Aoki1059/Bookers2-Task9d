class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  # フォローアンフォロー処理
  def create
    # params[:user_id]これはリンクから送られてきたuser_idをparamsで受け取っている
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end
  # フォローを外す時
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  # フォロー一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end
  # フォロワー一覧
  def followers
    user = User.find(params[:user_id])
    @user = user.followers
  end
end
