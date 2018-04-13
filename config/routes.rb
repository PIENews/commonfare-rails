Rails.application.routes.draw do



  # ************* ADMIN START **********
  devise_for :admin_users
  namespace :admin do
    resources :users
    resources :comments
    resources :commoners
    resources :images
    resources :stories
    resources :tags

    root to: "users#index"
  end
  # ************* ADMIN END **********

  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    },
    path: "auth",
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      password: 'secret',
      confirmation: 'verification',
      unlock: 'unblock',
      registration: 'register',
      sign_up: 'signup'
    }

  devise_scope :user do
    # see https://github.com/plataformatec/devise/wiki/how-to:-define-resource-actions-that-require-authentication-using-routes.rb
    authenticate :user do
      get 'auth/goodbye', to: 'users/registrations#goodbye', as: 'goodbye'
    end
  end

  scope "(:locale)", locale: /en|it|nl|hr/ do
    get :search, controller: :main
    get :autocomplete, controller: :main, defaults: { format: :json }
    resources :stories do
      # :index used for stories/42/comments, visible only by story's author
      resources :comments, only: [:index, :create]
      post :publish, on: :member
      get :preview, on: :member
    end
    get 'story_builder', to: 'stories#builder'

    resources :commoners, except: [:index] do
      resources :stories, only: :index
      # :index used for commoner/42/comments, visible only by comments' author
      resources :comments, only: :index
      resources :images, only: [:create, :destroy]
      # get 'wallet', to: 'wallets#show', as: 'wallet'
      resources :wallets, only: [:show]
      post 'transaction_confirm', to: 'transactions#confirm', as: 'transaction_confirm'
      resources :transactions, except: [:edit, :update, :destroy]
    end
    resources :comments, except: [:new, :show, :index]
    resources :tags, only: :show

    get :welcome, controller: :commoners

    get "/pages/*id" => 'pages#show', as: :page, format: false
    root to: 'pages#show', id: 'home'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
