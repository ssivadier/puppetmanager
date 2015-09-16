class SystemusersController < ApplicationController
  before_action :set_systemuser, only: [:show, :edit, :update, :destroy]

  # GET /systemusers
  def index
    @systemusers = Systemuser.all.order(:systemrole_id, :uid)
  end

  # GET /systemusers/1
  def show
  end

  # GET /systemusers/new
  def new
    @systemuser = Systemuser.new
  end

  # GET /systemusers/1/edit
  def edit
  end
  
  def import
    output = Import.new.call
    if output.is_a?(Hash)
      redirect_to :systemusers
      MyLog.info "[#{session[:user_uid]}][#{self.class.name}] has imported user.yaml file"
    else
      redirect_to :systemusers, alert: "System user '#{output}' has no valid definition in the user.yaml file. Missing informations."
    end
  end

  def export
    Export.new(Systemrole.all).call
    redirect_to :systemusers
    MyLog.info "[#{session[:user_uid]}][#{self.class.name}] has exported user.yaml file"
  end
  
  # POST /systemusers
  def create
    @systemuser = Systemuser.new(systemuser_params)

    if @systemuser.save
      redirect_to @systemuser, notice: "Systemuser #{@systemuser.name} was successfully created."
      MyLog.info "[#{session[:user_uid]}][#{self.class.name}] has created a new system user #{@systemuser.name}"
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /systemusers/1
  def update
    if @systemuser.update(systemuser_params)
      modified_username = Systemuser.find(params[:id]).name
      redirect_to @systemuser, notice: "Systemuser #{modified_username} was successfully updated."
      MyLog.info "[#{session[:user_uid]}][#{self.class.name}] has successfully updated system user #{modified_username}"
    else
      render action: 'edit'
    end
  end

  # DELETE /systemusers/1
  def destroy
    modified_username = @systemuser.name
    @systemuser.destroy
    redirect_to systemusers_url, notice: "#{modified_username} was successfully destroyed."
    MyLog.info "[#{session[:user_uid]}][#{self.class.name}] has removed system user #{modified_username}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_systemuser
      @systemuser = Systemuser.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def systemuser_params
      params.require(:systemuser).permit(:name, :uid, :ensure, :comment, :manage_home, :password, :sshkey, :sshkeytype, :keyfile, :shell_id, :systemrole_id)
    end
end
