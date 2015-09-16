class PuppetModule < ActiveRecord::Base


  # -------------------
  #  Method: Get the currently deployed version of a module in an environment
  # -------------------
  def self.get_current_selected_version(modulename, environment)			
	
    puppet_conf_dir = PuppetManager::Application::PUPPET_ENV_DIR+environment+"/Puppetfile"
    
    if File.exist?(puppet_conf_dir)    # If the librarian-puppet conf file exists
      selected_version = ""

      File.open(puppet_conf_dir).each{|line|                    # We read the file line by line
        if(line =~ /\'#{modulename}\'/)                             # if it's the module name's line
          mod, git, ref = line.scan(/'[^']*'/).flatten.compact  # We split the line to get the ref back
          unless ref.nil?
            selected_version = ref.strip.gsub(/\'/,'')          # We strip the ' character out of the string
          end
        end
      }
      
      if selected_version.empty?
        PuppetModule.where('name'=>modulename,'environment'=>environment)[0].id
      else
        unless PuppetModule.where('name'=>modulename,'version'=>selected_version,'environment'=>environment).empty? # unless finally the branch pointed in the file has no correspondance with what acctually exists in the git repo
          PuppetModule.where('name'=>modulename,'version'=>selected_version,'environment'=>environment)[0].id   # And finally get the id
        end
      end
    end
  end
  # -------------------
  
  # -------------------
  #  Method: Populate the DB with git ls-remote
  # -------------------
  def self.set_db_from_git(environment)
    environment_dir = PuppetManager::Application::PUPPET_ENV_DIR+environment # le path complet de l'environnement
    if File.directory?(environment_dir)	# if the directory really exists
      Dir.chdir(environment_dir) do
        # Read the puppetfile
        File.open("Puppetfile").each do |line|
          line.chomp!
          next if line.empty?
          next if line.include? "#"
          
          mod, git, ref = line.scan(/'[^']*'/).flatten.compact  # Clean the line and cut in 3, anything between ''
          command_output = `git ls-remote #{git} | grep -v '{}' | grep -v 'master'| awk '{print $2}' |cut -d '/' -f3 2>&1`
          
          if $? == 0   #check if the child process exited cleanly.
            *list_git_tags = command_output.split
            list_git_tags.map do | module_tag |		# For each tag in git, we check if it exists or create it
              name = mod.strip.gsub(/\'/,'')		# Remove all '
              PuppetModule.where('name'=>name, 'version'=>module_tag, 'url'=>git, 'environment'=>environment).first_or_create # Fill in the DB
            end
          else  # if the git command failed
            return 'The git repository is not available : <strong>'+git+'</strong><br /><pre>'+command_output+'</pre>'
          end
        end
      end
    else  # if the directory doesn't exist
      return 'This directory : <strong>'+PuppetManager::Application::PUPPET_ENV_DIR+'</strong> does not exist.<br />Please change the value in the Initializer file.'
    end
  end
  # -------------------
	  
    
  # -------------------
  #  Method: Write to a file
  # -------------------    
  def self.write_to_file(path,file,content)
    if File.directory?(path)
      Dir.chdir(path) do
        fh = File.new(file, "w")
        fh.write(content)
        fh.close
      end
    else
      redirect_to puppet_modules_path, alert: 'This directory : <strong>#{path}</strong> does not exist.<br />'
    end
  end
  # -------------------
end
