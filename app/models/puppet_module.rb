class PuppetModule < ActiveRecord::Base


  # -------------------
  #  Method: Get the currently deployed version of each module
  # -------------------
  def self.get_current_selected_version(modulename)			
		
	if File.exist?(PuppetManager::Application::CONF_LIBRARIAN_PUPPET)    # If the librarian-puppet conf file exists
		selected_version = ""
			
		File.open(PuppetManager::Application::CONF_LIBRARIAN_PUPPET).each{|line|    # Then we read it to get the version number
			if(line =~ /#{modulename}.*ref\s=>\s\'#{modulename}\-(.*?)\'/)
				selected_version = $1
			end
		}
			
		PuppetModule.where('name'=>modulename,'version'=>selected_version)[0].id   # And finally get the id
	end
  end
  # -------------------
	  
end
