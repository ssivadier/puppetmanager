class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: "User #{@user.uid} was successfully created."
      MyLog.info "[#{session[:user_uid]}][#{self.class.name}] has created a new user '#{@user.uid}'."
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: "User #{@user.uid} was successfully updated."
      MyLog.info "[#{session[:user_uid]}][#{self.class.name}] has updated a new user '#{@user.uid}'."
    else
      render action: 'edit'
    end
  end

  # DELETE /users/1
  def destroy
    removed_user = @user.uid
    @user.destroy
    redirect_to users_url, notice: "User #{removed_user} was successfully destroyed."
      MyLog.info "[#{session[:user_uid]}][#{self.class.name}] has removed a new user '#{removed_user}'."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:uid)
    end
end
