class WinemakersController < ApplicationController
  before_action :set_winemaker, only: %i[ show edit update destroy ]

  # GET /winemakers or /winemakers.json
  def index
    @winemakers = Winemaker.all
  end

  # GET /winemakers/1 or /winemakers/1.json
  def show
  end

  # GET /winemakers/new
  def new
    @winemaker = Winemaker.new
  end

  # GET /winemakers/1/edit
  def edit
  end

  # POST /winemakers or /winemakers.json
  def create
    @winemaker = Winemaker.new(winemaker_params)

    respond_to do |format|
      if @winemaker.save
        format.html { redirect_to @winemaker, notice: "Winemaker was successfully created." }
        format.json { render :show, status: :created, location: @winemaker }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @winemaker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /winemakers/1 or /winemakers/1.json
  def update
    respond_to do |format|
      if @winemaker.update(winemaker_params)
        format.html { redirect_to @winemaker, notice: "Winemaker was successfully updated." }
        format.json { render :show, status: :ok, location: @winemaker }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @winemaker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /winemakers/1 or /winemakers/1.json
  def destroy
    @winemaker.destroy
    respond_to do |format|
      format.html { redirect_to winemakers_url, notice: "Winemaker was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_winemaker
      @winemaker = Winemaker.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def winemaker_params
      params.require(:winemaker).permit(:name, :old, :nationality, :work, :is_editor, :is_writer, :is_reviewer)
    end
end
