module PuppetManager
  class Application
	#PUPPET MANAGER APP
    VERSION			= "2.2.3"
    TITLE			= "PUPPET MANAGER"
    
    #EXTERNAL LINKS
    DASHBOARD_LINK	= ENV["DASHBOARD_LINK"]
      
	#DIRS AND FILES
	LOCAL_GIT_REPO = ENV["GIT_REPO"] || "/usr/share/repositories/"
	CONF_LIBRARIAN_PUPPET = ENV["CONF_LIBRARIAN_PUPPET"] || "/etc/puppet/Puppetfile"
  end
end
