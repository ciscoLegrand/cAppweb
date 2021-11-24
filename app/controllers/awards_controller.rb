class AwardsController < ApplicationController
  
  before_action :set_award, only: %i[ show edit update destroy ]

  # GET /awards or /awards.json
  def index
    add_breadcrumb 'Premios'
    @headers = ['TITULO', 'CONTENIDO'] 
    @attrs = [:title,:body ] 
    @awards = Award.first
  end

  # GET /awards/1 or /awards/1.json
  def show
    add_breadcrumb 'Premios', awards_path
    add_breadcrumb @award.id
    @awards = Award.first
  end

  # GET /awards/new
  def new
    add_breadcrumb 'Premios', awards_path
    add_breadcrumb 'Nuevo'
    @award = Award.new
  end

  # GET /awards/1/edit
  def edit
    add_breadcrumb 'Premios', awards_path
    add_breadcrumb "Editar #{ @award.id } "
  end

  # POST /awards or /awards.json
  def create
    @award = Award.new(award_params)

    respond_to do |format|
      if @award.save
        format.html { redirect_to @award, notice: "Award was successfully created." }
        format.json { render :show, status: :created, location: @award }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /awards/1 or /awards/1.json
  def update
    respond_to do |format|
      if @award.update(award_params)
        format.html { redirect_to @award, notice: "Award was successfully updated." }
        format.json { render :show, status: :ok, location: @award }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /awards/1 or /awards/1.json
  def destroy
    @award.destroy
    respond_to do |format|
      format.html { redirect_to awards_url, notice: "Award was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_award
      @award = Award.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def award_params
      params.require(:award).permit(:title, :body, images: [])
    end
end
