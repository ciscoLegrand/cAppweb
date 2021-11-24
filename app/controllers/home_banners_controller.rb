class HomeBannersController < ApplicationController
  
  before_action :set_home_banner, only: %i[ show edit update destroy ]

  # GET /home_banners or /home_banners.json
  def index
    add_breadcrumb 'Banners Inicio'
    @headers = ['TITULO', 'CONTENIDO','POSICION','PARALLAX','VISIBLE'] 
    @attrs = [:title,:body_truncate,:position, :parallax, :visible, ] 
    @pagy,@home_banners = pagy(HomeBanner.all, items:10)
  end

  # GET /home_banners/1 or /home_banners/1.json
  def show
    add_breadcrumb 'Banners Inicio', home_banners_path
    add_breadcrumb @home_banner.title
  end

  # GET /home_banners/new
  def new
    add_breadcrumb 'Banners Inicio', home_banners_path
    add_breadcrumb 'Nuevo'
    @home_banner = HomeBanner.new
  end

  # GET /home_banners/1/edit
  def edit
    add_breadcrumb 'Banners Inicio', home_banners_path
    add_breadcrumb "Editar #{@home_banner.title}"
  end

  # POST /home_banners or /home_banners.json
  def create
    @home_banner = HomeBanner.new(home_banner_params)

    respond_to do |format|
      if @home_banner.save
        format.html { redirect_to @home_banner, notice: "Home banner was successfully created." }
        format.json { render :show, status: :created, location: @home_banner }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @home_banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /home_banners/1 or /home_banners/1.json
  def update
    respond_to do |format|
      if @home_banner.update(home_banner_params)
        format.html { redirect_to @home_banner, notice: "Home banner was successfully updated." }
        format.json { render :show, status: :ok, location: @home_banner }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @home_banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /home_banners/1 or /home_banners/1.json
  def destroy
    @home_banner.destroy
    respond_to do |format|
      format.html { redirect_to home_banners_url, notice: "Home banner was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_home_banner
      @home_banner = HomeBanner.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def home_banner_params
      params.require(:home_banner).permit(:parallax,:title,:body,:position,:order,:visible,:image)
    end
end
