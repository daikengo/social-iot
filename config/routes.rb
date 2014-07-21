Siot::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :user_admins

  

  resources :places
    # main data posts using this route
  match 'update', :to => 'channels#post_data', :as => 'update', :via => :post
  match 'profile', :to => 'channels#post_profile', :as => 'profile', :via => :post
  match 'friendship(.:format)', :to => 'channels#friendship_list', :as => 'friendship', :via => :post
  match 'group_membership(.:format)', :to => 'channels#groupmembers', :as => 'group_membership', :via => :post
  match 'channels/:channel_id/status(.:format)' => 'status#show', :via => ((GET_SUPPORT) ? ['get', 'post'] : 'post')
  # handle subdomain routes
  match '/', :to => 'subdomains#index', :constraints => { :subdomain => 'api' }
  match 'crossdomain', :to => 'subdomains#crossdomain', :constraints => { :subdomain => 'api' }
  match 'crossdomain', :to => 'subdomains#crossdomain'
  match 'places/nearbys(.:format)' => 'places#nearbys', :as => 'nearbys', :via => :post
  root :to => 'pages#home'
  match 'user_guide', :to => 'pages#user_guide'
  match 'developer_guide', :to => 'pages#developer_guide'
  match 'terms', :to => 'pages#terms'
  resource :user_session
  resource 'account', :to => 'users'
  resources :users do
    member do      
      get :reset_password
      put :change_password
    end
    collection do
      get :forgot_password
    end
  end
  # specific feeds
  match 'channels/:channel_id/feed(s)(.:format)' => 'feed#index'
  match 'channels/:channel_id/field(s)/:field_id(.:format)' => 'feed#index'
  match 'channels/:channel_id/field(s)/:field_id/:id(.:format)' => 'feed#show'
  match 'channels/:channel_id/feed(s)/entry/:id(.:format)' => 'feed#show'
  # import
  match 'channels/:channel_id/import' => 'channels#import', :as => 'channel_import'
  match 'channels/:channel_id/upload' => 'channels#upload'

  # nest feeds into channels
  resources :channels do
    member do
      get :import
      post :upload
      post :clear
    end
    resources :feed
    resources :feeds, :to => 'feed'
    resources :api_keys, :except => [:show, :edit, :new]
    resources :status
    resources :statuses, :to => 'statuses'
    resources :charts
  end

  match 'login' => 'user_sessions#new', :as => :login, :via => :get
  match 'logout' => 'user_sessions#destroy', :as => :logout, :via => :delete
  match 'mailer/resetpassword', :to => 'mailer#resetpassword', :as => :resetpassword, :via => :post
end
