class SystemrolesController < ApplicationController
  before_action :set_systemrole, only: [:show, :edit, :update, :destroy]

  # GET /systemroles
  def index
    @systemroles = Systemrole.all.order(:name, :gid)
  end

  # GET /systemroles/1
  def show
  end

  # GET /systemroles/new
  def new
    @systemrole = Systemrole.new
    @systemrole.optgroups.build
  end

  # GET /systemroles/1/edit
  def edit
    @systemrole.optgroups.build
  end

  # POST /systemroles
  def create
    @systemrole = Systemrole.new(systemrole_params)

    if @systemrole.save
      redirect_to @systemrole, notice: "Role #{@systemrole.name} was successfully created."
      MyLog.info "[#{session[:user_uid]}][#{self.class.name}] has successfully created system role #{@systemrole.name}"
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /systemroles/1
  def update
    if @systemrole.update(systemrole_params)
      modified_role = Systemrole.find(params[:id]).name
      redirect_to @systemrole, notice: "Role #{modified_role} was successfully updated."
      MyLog.info "[#{session[:user_uid]}][#{self.class.name}] has successfully updated system role #{modified_role}"
    else
      render action: 'edit'
    end
  end

  # DELETE /systemroles/1
  def destroy
    modified_role = @systemrole.name
    @systemrole.destroy
    redirect_to systemroles_url, notice: "Role #{modified_role} was successfully destroyed."
    MyLog.info "[#{session[:user_uid]}][#{self.class.name}] has successfully removed system role #{modified_role}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_systemrole
      @systemrole = Systemrole.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def systemrole_params
      params.require(:systemrole).permit(:name, :gid, optgroups_attributes: [ :id, :name, :_destroy ])
    end
end
