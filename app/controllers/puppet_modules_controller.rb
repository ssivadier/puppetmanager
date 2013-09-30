class PuppetModulesController < ApplicationController
  before_action :set_puppet_module, only: [:show, :edit, :update, :destroy]

  # -------------------
  #  Method: Shows modules and their available versions based on git tags
  # -------------------
  def index
	if File.directory?(PuppetManager::Application::LOCAL_GIT_REPO)	# if the directory really exists (check /config/Initializer/PuppetManager.rb)
		Dir.chdir(PuppetManager::Application::LOCAL_GIT_REPO) do
			command_output = `git tag 2>&1`	
			if $? == 0   #check if the child process exited cleanly.
				*list_git_tags = command_output.split
				
				list_git_tags.map do | module_tag |    # For each tag in git, we check if it exists or create it
					name, module_version = module_tag.split(/-/)
					PuppetModule.where('name'=>name, 'version'=>module_version).first_or_create
				end
			
			else  # if the git command failed
				redirect_to :back, alert: 'The git repository is not available at : <strong>'+PuppetManager::Application::LOCAL_GIT_REPO+'</strong><br /><pre>'+command_output+'</pre>'
			end
		end
		
		@puppet_module =  PuppetModule.select('DISTINCT(name) as "name"')
	else  # if the directory doesn't exist
		redirect_to :back, alert: 'This directory : <strong>'+PuppetManager::Application::LOCAL_GIT_REPO+'</strong> does not exist.<br />Please change the value in the Initializer file.'
	end
  end
  # -------------------
  
  
  # -------------------
  #  Method: Apply modules' versions to puppet prod environment
  # -------------------  
  def apply
	if params.has_key?(:version)
	
		git_url = "http://my_repo/"	
		content = ""    # Create all the content for the Puppetfile
		PuppetModule.find(params[:version]).each do |mod|
			content << "\n\nmod '"+mod.name+"', :git =>'${git_url}', :ref => '"+mod.name+"-"+mod.version+"', :path => 'modules/"+mod.name+"'"
		end
		
		if File.directory?("/etc/puppet/")
			Dir.chdir("/etc/puppet/") do
				fh = File.new("Puppetfile", "w")       # Write down the /etc/puppet/Puppetfile for librarian-puppet gem
				fh.write(content)
				fh.close
			end
		else
			redirect_to puppet_modules_path, alert: 'This directory : <strong>/etc/puppet/</strong> does not exist.<br />Please install puppet gem.'
		end
		
		command_output = `librarian-puppet update 2>&1`   # Call for an update of the puppet module folder
		
		if $? == 0
			redirect_to puppet_modules_path, notice: 'Puppet production environment modules have been correctly updated.'
		else
			redirect_to puppet_modules_path, alert: 'Something crashed during puppet modules update.<br /><pre>'+command_output+'</pre>'
		end
	else
		redirect_to nodes_path, alert: "No version has been specified, or incorrect version. Please, try again."
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

  def destroy
    @puppet_module.destroy
    respond_to do |format|
      format.html { redirect_to puppet_modules_url }
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
