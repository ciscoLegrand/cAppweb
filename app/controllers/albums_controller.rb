class AlbumsController < ApplicationController
  
  before_action :set_album, only: %i[ show edit update destroy ]
  
  # GET /albums or /albums.json
  def index
    add_breadcrumb 'Galerías'
    @headers = ['TITULO', 'FECHA','CONTRASEÑA']
    @attrs =  [:title, :date_event, :password]
    @albums = Album.order('date_event DESC').all
    @pagy, @albums = pagy(@albums, items: 10)
  end
  
  # GET /albums/1 or /albums/1.json
  def show
    add_breadcrumb 'Galerías', albums_path
    add_breadcrumb @album.title
    
    @total_images = 0 
    @album.galleries.each {|gal| @total_images += gal.images.length }
    
    @gallery = Gallery.where(album_id: @album)
    # @images = Gallery.where(album_id: @album).first.images
    # @pagy, @gallery  = pagy(@images, items: 50)

  end

  # GET /albums/new
  def new
    add_breadcrumb 'Galerías', albums_path
    add_breadcrumb 'Nuevo'
    @album = Album.new
  end

  # GET /albums/1/edit
  def edit
    add_breadcrumb 'Galerías', albums_path
    add_breadcrumb  "Editar #{@album.title}"
  end

  # POST /albums or /albums.json
  def create
    @album = Album.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: "Album was successfully created." }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1 or /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to albums_path, notice: "Album was successfully updated." }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1 or /albums/1.json
  def destroy
 
    # handle selective purge
    if params[:attachment_id]
      @album.files.find_by_id(params[:attachment_id]).purge
      @album.destroy
    # handle purge all
    elsif params[:purge]
      @album.files.purge
      @album.destroy
    # handle destroy resource
    else
      @album.destroy
    end

    respond_to do |format|
      format.html { redirect_to albums_url, notice: "Album was successfully destroyed." }
      format.json { head :no_content }
    end


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def album_params
      params.require(:album).permit(:title,:date_event,:wedding_guest, :password, :likes, :order, :position,:visitors)
    end
end
