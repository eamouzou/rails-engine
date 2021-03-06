Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do

      get '/revenue', to: 'total_revenue#show'

      namespace :items do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
      end

      namespace :merchants do
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get '/most_revenue', to: 'revenues#index'
        get '/most_items', to: 'most_items#index'
        get '/:merchant_id/revenue', to: 'revenues#show'
      end

      resources :merchants, except: [:new, :edit] do
        resources :items, only: [:index]
      end

      resources :items, except: [:new, :edit] do
        get '/merchant', to: "merchants#show"
      end

    end
  end
end
