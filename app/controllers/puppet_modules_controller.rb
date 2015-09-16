class PuppetModulesController < ApplicationController
  before_action :set_puppet_module, only: [:show, :edit, :update, :destroy]

  # -------------------
  #  Method: Shows modules and their available versions based on git tags
  # -------------------
  def index
    if File.directory?(PuppetManager::Application::PUPPET_ENV_DIR)
      Dir.chdir(PuppetManager::Application::PUPPET_ENV_DIR)  do# on chdir dans le puppet_env_dir (check /config/Initializer/PuppetManager.rb)
     #   @list_env = ["production","installation"].concat(Dir["Qual_*"].reject{|o| not File.directory?(o)}) # liste les repertoires commencant par "Qual_" en plus des environnements production et installation
        @list_env = ["production","installation"] # Pour le moment je ne liste pas tous les environnements.
        
        @env = params[:environment] # get the environment param
        
        if @env.nil? # on first page load, there's no environment param => default to "production"
          @env = "production"
        end
        
        output = PuppetModule.set_db_from_git(@env)
        if output.is_a?(String)
          redirect_to :back, alert: output
        end
        
        # @puppet_module = PuppetModule.where('environment'=>@env).select(:name, :id).group(:name).page(params[:page]).per(10)
        @puppet_module = PuppetModule.where('environment'=>@env).select(:name, :id).group(:name)
      end
    else
      redirect_to welcome_path, alert: "The path #{PuppetManager::Application::PUPPET_ENV_DIR} does not exist."
      logger.error "[#{session[:user_uid]}] The path #{PuppetManager::Application::PUPPET_ENV_DIR} does not exist."
    end
  end
  # -------------------  
  
  
  # -------------------
  #  Method: Apply modules' versions to puppet environment
  # -------------------  
  def apply
    if params.has_key?(:version)
      
      content = ""
      command_output = ""
      environment = params[:env][0]
      environment_path = PuppetManager::Application::PUPPET_ENV_DIR + environment
      
      # Prepare the puppetfile content
      PuppetModule.find(params[:version]).each do |mod|
        content << "\nmod '"+mod.name+"', :git =>"+mod.url+", :ref => '"+mod.version+"'"
      end
      
      # write it down
      PuppetModule.write_to_file(environment_path,"Puppetfile.#{PuppetManager::Application::PM_SITE}",content)
      
      # now updates modules folder
      command_output = `sudo #{PuppetManager::Application::PUPPET_ENV_DIR}/production/scripts/master-sync #{environment} 2>&1 /dev/null`
      
      if $? == 0
        # then back to modules' page
        redirect_to puppet_modules_path, notice: "Puppet #{environment} environment modules has been updated."
        MyLog.info "[#{session[:user_uid]}][#{self.class.name}] updated puppet modules of #{environment} environment."
      else
        redirect_to puppet_modules_path, alert: "There was an issue updating the modules list. #{environment} environment is not up-to-date (master-sync failed)."
        logger.error "[#{session[:user_uid]}] #{environment} environment could not be updated (master-sync failed)."
      end
    else
      redirect_to nodes_path, alert: "No version has been specified, or incorrect version. Please, try again."
      logger.error "[#{session[:user_uid]}] incorrect version syntax in module page."
    end
  end
  # ------------------- 
  
  
  def update
    respond_to do |format|
      if @puppet_module.update(puppet_module_params)
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
      end
    end
  end
  
  def show
    @module_name = PuppetModule.find(params[:id]).name
    module_environment = PuppetModule.find(params[:id]).environment
    @module_versions = PuppetModule.where('environment'=>module_environment).where('name'=>@module_name).order('version')
  end
  
  def diff
    @puppet_module = PuppetModule.find(params[:ids])
    module_url = @puppet_module.first.url
    @module_name = @puppet_module.first.name.split('/')[1]
    Dir.chdir("tmp") do
      command_output = `git clone #{module_url} 2>&1`
      if $? == 0   #check if the child process exited cleanly.
        Dir.chdir("puppet-#{@module_name}") do
          @puppet_module.sort! { |a,b| a.id <=> b.id }
          @diff_output = `git diff --stat --summary #{@puppet_module[0].version}..#{@puppet_module[1].version}`
          @command = "git diff --stat --summary #{@puppet_module[0].version}..#{@puppet_module[1].version}"
        end
        command_output = `rm -rf puppet-#{@module_name} 2>&1`
      else  # if the git command failed
        redirect_to :back, alert: 'The git repository is not available : <strong>git clone #{module_url}</strong><br /><pre>'+command_output+'</pre>'
      end
    end
  end

  def destroy
    @puppet_module.destroy
    respond_to do |format|
      format.html { redirect_to puppet_modules_url }
    end
  end

  # GET /puppet_modules/new
  def create
    name = session[:user_uid].split('@')[0]
    final_name = name.chars.first + name.split('.')[1]
    
    if File.directory?("#{PuppetManager::Application::PUPPET_ENV_DIR}/Qual_#{final_name}")
      redirect_to puppet_modules_path, warning: "Environment Qual_#{final_name} already exists"
    else
      command_output = `sudo /etc/puppet/environments/production/scripts/create-environment Qual_#{final_name}`
      
      if $? == 0
        redirect_to puppet_modules_path, notice: "Environment Qual_#{final_name} has been correctly created"
      else
        redirect_to puppet_modules_path, alert: "Environment Qual_#{final_name} hasn't been created"
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_puppet_module
      @puppet_module = PuppetModule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def puppet_module_params
      params.require(:puppet_module).permit(:name, :version)
    end
end
