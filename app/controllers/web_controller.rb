class WebController < ApplicationController
  before_action :set_main_service, only: %w[web_services web_service ]
  before_action :set_service, only: %w[web_service]
  before_action :set_cart

  def web_home
    @home = true
    @banner_uno = HomeBanner.first
    @banner_dos = HomeBanner.second
    @banner_tres = HomeBanner.third
    @awards = Award.first
    @opinions = Opinion.all
    @abouts = About.all
    @about = @abouts.first
  end 

  def web_about_us
    @abouts = About.all
    @about = @abouts.first
  end


  def web_services
    add_breadcrumb @main_service.name, main_service_path(@main_service)
    @services = Cadmin::MainService.friendly.find(params[:main_service_id]).services.friendly.where(params[:service_id])
  end

  def web_service
    add_breadcrumb @service.name, servicio_path
  end

  def web_search_results
    add_breadcrumb "Albumes", resultados_path
    if params.has_key?(:title) && params[:title].length > 0
      @albums = Album.title(params[:title])
    else
      @albums = Album.all
    end
  end
  
  def web_albums
    add_breadcrumb "Galerias", galerias_path
    if params.has_key?(:title) && params[:title].length > 0
      @albums = Album.title(params[:title])
    else
      @albums = Album.date.all
    end

    if params.has_key?(:password) && params[:password].length > 0
      @albums = Album.password(params[:password])
    else
      @albums = Album.date.all
    end

  end 

  def web_album
    @album = Album.find(params[:album_id])
    add_breadcrumb @album.title, galeria_path(@album)
    @total_images = 0 
    @album.galleries.each { |gal| @total_images += gal.images.length }
    @password = @album.password
    
    if params.has_key?(:password) && params[:password].length > 0 && params[:password] == @password
      @album = Album.find(params[:album_id])
      @gallery = Gallery.where(album_id: Album.find(params[:album_id]))
      @images = Gallery.where(album_id: Album.find(params[:album_id])).first.images
      @pagy, @gallery  = pagy(@images, items: 100)
    else
      redirect_to galerias_path
    end
  end 
  
  def web_contact
    add_breadcrumb 'Contacto', contacto_path
    @contact = Contact.new
    @cabinas = Cadmin::Service.where(main_service_id: 1)
    @main_services = Cadmin::MainService.where.not(id: 1)
  end

  def web_cart 
    add_breadcrumb 'Carrito'
    @total_cart_amount = @cart.total_cart_amount
    @main_service = @main_service
  end
    
  def web_checkout_success 
  end
  def web_checkot_cancel 
  end
  
  private 
    def set_main_service 
      @main_service =  Cadmin::MainService.friendly.find(params[:main_service_id])
    end 
    def set_service 
      @service = Cadmin::Service.friendly.find(params[:service_id])
    end 
    def set_cart 
      @cart = Cadmin::Cart.find(session[:cart_id]) if session[:cart_id].present?
    end
end
