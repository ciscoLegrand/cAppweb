Rails.application.routes.draw do
  constraints(host: 'picmaton.com') do
    get '(*)', to: redirect(host: 'lagramoladisco.com/galerias')
  end

  resources :service_objects
  resources :web_configs
  root 'web#web_home'
  
  resources :contacts, only: [:create, :new]

  resources :albums do
    resources :galleries
  end
  
  resources :opinions do
    match '/scrape', to: 'opinions#scrape', via: :post, on: :collection
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
  post "/contacts/new"
  resources :abouts
  resources :awards
  resources :home_banners
  resources :photos
  resources :quotes
 
  match 'sobre-nosotros', to: 'web#web_about_us', via: :get
  match 'galerias', to: 'web#web_albums', via: :get
  match 'contacto', to: 'web#web_contact',via: :get
  match 'resultados', to: 'web#web_search_results', via: :get
  match 'servicios', to: 'web#web_services', via: :get
  match 'politica-de-cookies', to: 'web#web_aviso_cookies', as: 'cookies', via: :get
  match 'aviso-legal', to: 'web#web_aviso_legal', as: 'legal', via: :get
  match 'politica-de-privacidad', to: 'web#web_aviso_privacidad', as: 'privacidad', via: :get
  match 'usuarios', to: 'users#index', via: :get
  match 'email-contacto', to: "contacts#index", via: :get
  get '/galeria/:album_id', to: 'web#web_album', as: 'galeria'
  get '/servicios/:service_id', to: 'web#web_service', as: 'servicio'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users, :controllers => { 
    sessions: 'users/sessions',
    registrations: 'users/registrations' 
  }

  as :user do
    get 'users/edit' => 'users/registrations#edit'
    put 'users/edit' => 'users/registrations#create', :as => 'registrations'
    get 'login' => 'users/sessions#new'
    post 'login' => 'users/sessions#create'
    get 'signup' => 'users/registrations#new'
    post 'signup' => 'users/registrations#create'
    get 'logout' => 'users/sessions#destroy'
    delete 'logout' => 'users/sessions#destroy'
  end
  # devise_for :users do
  #   # to solve the error [No route matches [GET] "/users/sign_out"]  => https://stackoverflow.com/questions/6567863/no-route-matches-get-users-sign-out
  #   #devise_scope :users do
  #   get '/users/sign_out'   => 'devise/sessions#destroy'
  # end

  mount Cadmin::Engine => '/cadmin'


end
