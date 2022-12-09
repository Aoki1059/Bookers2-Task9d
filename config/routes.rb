Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to: "homes#top"
  get "home/about" => "homes#about"

  # Searchesコントローラのsearchアクションが実行されるように定義
  get "search" => "searches#search"

  resources :books, only:[:index, :show, :edit, :create, :destroy, :update] do
    # 投稿に紐付けする
    resources :book_comments, only:[:create, :destroy]
    resource :favorites, only:[:create, :destroy]
  end
  # フォロー機能をusers用のURL用に設定する
  resources :users, only:[:index, :show, :edit, :update, :create] do
    # フォロー機能をuserにネストする
    # user_idに基づいて、フォロー、アンフォローするので、user_idにネストすることでurlにidを含める
    resource :relationships, only:[:create, :destroy]
    # フォローの一覧画面の記述
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :chats, only: [:show, :create]

end