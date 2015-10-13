module PuppetManager
  class Application
    # PUPPET MANAGER APP
    VERSION			= "2.8.3"
    TITLE			= "PUPPET MANAGER"
      
    # EXTERNAL LINKS
    DASHBOARD_LINK	= ENV["DASHBOARD_LINK"] || "http://puppetdashboard.app.sen.centre-serveur.i2/"
    REDMINE_LINK = ENV["REDMINE_LINK"] || "https://portail.centre-serveur.i2/"
    GIT_MANIFEST_REPO = ENV["GIT_MAN_REPO"] || "http://admin:admin@git.ac.centre-serveur.i2/puppet-manifests.git"
        
    # DIRS AND FILES
    PUPPET_ENV_DIR = ENV["PUPPET_ENV_DIR"] || "/etc/puppet/environments/"
    CONF_LIBRARIAN_PUPPET = ENV["CONF_LIBRARIAN_PUPPET"] || "/etc/puppet/environments/production/Puppetfile"
    
    # NETWORK
    LOCAL_IP = `ip a |grep inet |grep -v 127.0.0.1`.match(/inet (\d*\.\d*\.\d*\.\d*)\/\d*/)[0]
    if LOCAL_IP =~ /172.22/
      PM_SITE = "bordeaux"
    else
      PM_SITE = "paris"
    end
    
  end
end
