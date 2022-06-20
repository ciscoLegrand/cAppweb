Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  constraints(host: 'picmaton.com') do
    get '(*)', to: redirect(host: 'lagramoladisco.com/galerias')
  end

  require 'sidekiq/web'
  authenticate :cadmin_user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => 'cadmin/sidekiq'
  end


  root 'web#web_home'

  resources :web_configs
  
  resources :albums do
    resources :galleries
  end
  
  resources :opinions do
    match '/scrape', to: 'opinions#scrape', via: [:get, :post], on: :collection, as: :scrape
  end
  
  resources :todo_lists do
    resources :todo_items
  end
  
  resources :services do 
    resources :service_items
  end
  
  resources :service_items do
    collection do
      patch :sort
    end
  end
  
  resources :contacts, only: [:create, :new]
  # post "/contacts/new"
  resources :abouts
  resources :awards
  resources :home_banners
  resources :photos
  resources :quotes
  resources :service_objects
  
  # custom routes for web public client access
  match 'carrito',                                          to: 'web#web_cart',                 via: [:get, :post], as: :cart
  match 'servicios/:main_service_id',                       to: 'web#web_services',             via: :get,          as: :main_service
  match 'servicios/:main_service_id/:service_id',           to: 'web#web_service',              via: :get,          as: :servicio
  match 'sobre-nosotros',                                   to: 'web#web_about_us',             via: :get
  match 'galerias',                                         to: 'web#web_albums',               via: :get
  match 'contacto',                                         to: 'web#web_contact',              via: :get
  match 'resultados',                                       to: 'web#web_search_results',       via: :get
  match 'profile/:user_id',                                 to: 'web#web_profile',              via: :get,          as: :profile
  match 'politica-de-cookies',                              to: 'web#web_aviso_cookies',        via: :get,          as: :cookies
  match 'aviso-legal',                                      to: 'web#web_aviso_legal',          via: :get,          as: :legal
  match 'politica-de-privacidad',                           to: 'web#web_aviso_privacidad',     via: :get,          as: :privacidad
  match 'usuarios',                                         to: 'users#index',                  via: :get
  match 'email-contacto',                                   to: "contacts#index",               via: :get
  get '/galeria/:album_id',                                 to: 'web#web_album',                                    as: :galeria
  
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  # devise_for :users, :controllers => { 
  #   sessions: 'users/sessions',
  #   registrations: 'users/registrations' 
  # }

  # as :user do
  #   get 'users/edit' => 'users/registrations#edit'
  #   put 'users/edit' => 'users/registrations#create', :as => 'registrations'
  #   get 'login' => 'users/sessions#new'
  #   post 'login' => 'users/sessions#create'
  #   get 'signup' => 'users/registrations#new'
  #   post 'signup' => 'users/registrations#create'
  #   get 'logout' => 'users/sessions#destroy'
  #   delete 'logout' => 'users/sessions#destroy'
  # end
  # devise_for :users do
  #   # to solve the error [No route matches [GET] "/users/sign_out"]  => https://stackoverflow.com/questions/6567863/no-route-matches-get-users-sign-out
  #   #devise_scope :users do
  #   get '/users/sign_out'   => 'devise/sessions#destroy'
  # end

  mount Cadmin::Engine => '/cadmin'


end
