PuppetManager::Application.routes.draw do

  resources :optgroups

  resources :systemroles

  get 'systemusers/import' => 'systemusers#import'
  get 'systemusers/export' => 'systemusers#export'
  resources :systemusers

  resources :users

  resources :puppet_modules, :except => ["new","edit"] do
	collection do
    get "/create" => "puppet_modules#create", :as => "create"
		post 'apply'
    post 'diff'
	end
  end

  resources :nodes, :except => ["new","create","edit"] do
	collection do
		get 'index_certified'
		post 'revoke'
		post 'certify'
	end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # omniauth / authentication routes
  get "/auth/:provider/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", :as => "signout"
  get "welcome/index", :as => "welcome"

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get '/change_locale/:locale', to: 'settings#change_locale', as: :change_locale

end
