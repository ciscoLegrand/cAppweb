class ServicesController < ApplicationController
  
  before_action :set_service, only: %i[ show edit update destroy ]

  # GET /services or /services.json
  def index
    add_breadcrumb 'Servicios'
    @headers = ['NOMBRE', 'DESCRIPCION']
    @attrs =  [:name,:description]
    @pagy, @services = pagy(Service.all, items: 10)
  end

  # GET /services/1 or /services/1.json
  def show
    add_breadcrumb 'Servicios', services_path
    add_breadcrumb @service.name
    @service_objects = ServiceObject.where(service_id: @service.id).all
  end

  # GET /services/new
  def new
    add_breadcrumb 'Servicios', services_path
    add_breadcrumb "Nuevo"
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
    add_breadcrumb 'Servicios', services_path
    add_breadcrumb "Editar #{@service.name}"
  end

  # POST /services or /services.json
  def create
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        format.html { redirect_to @service, notice: "Service was successfully created." }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1 or /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service, notice: "Service was successfully updated." }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1 or /services/1.json
  def destroy
     # handle selective purge
    if params[:attachment_id]
      @service.files.find_by_id(params[:attachment_id]).purge
      @service.destroy
    # handle purge all
    elsif params[:purge]
      @service.files.purge
      @service.destroy
    # handle destroy resource
    else
      @service.destroy
    end
    respond_to do |format|
      format.html { redirect_to services_url, notice: "Service was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def service_params
      params.require(:service).permit(:name, :description, :price, :image)
  
    end
end
