class OptgroupsController < ApplicationController
  before_action :set_optgroup, only: [:show, :edit, :update, :destroy]

  # GET /optgroups
  def index
    @optgroups = Optgroup.all
  end

  # GET /optgroups/1
  def show
  end

  # GET /optgroups/new
  def new
    @optgroup = Optgroup.new
  end

  # GET /optgroups/1/edit
  def edit
  end

  # POST /optgroups
  def create
    @optgroup = Optgroup.new(optgroup_params)

    if @optgroup.save
      redirect_to @optgroup, notice: 'Optgroup was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /optgroups/1
  def update
    if @optgroup.update(optgroup_params)
      redirect_to @optgroup, notice: 'Optgroup was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /optgroups/1
  def destroy
    @optgroup.destroy
    redirect_to optgroups_url, notice: 'Optgroup was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_optgroup
      @optgroup = Optgroup.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def optgroup_params
      params.require(:optgroup).permit(:name)
    end
end
