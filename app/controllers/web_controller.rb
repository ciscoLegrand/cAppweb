class WebController < ApplicationController
  def web_home
    @banner_uno = HomeBanner.first
    @banner_dos = HomeBanner.second
    @banner_tres = HomeBanner.third
    @awards = Award.first
    @opinions = Opinion.all
  end 

  def web_about_us
    @abouts = About.all
    @about = @abouts.first
  end

  def web_services
    @services = Service.all
  end

  def web_service
    @service = Service.find(params[:service_id])
  end
  
  def web_search_results
    if params.has_key?(:title) && params[:title].length > 0
      @albums = Album.title(params[:title])
    else
      @albums = Album.all
    end
  end
  
  def web_albums
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
    @password = @album.password

    if params.has_key?(:password) && params[:password].length > 0 && params[:password] == @password
      @album = Album.find(params[:album_id])
      @pagy, @galleries  = pagy(Album.find(params[:album_id]).galleries.all, items: 50)
    else
      redirect_to picmaton_path
    end
  end 
  
  def web_contact
  end
end
