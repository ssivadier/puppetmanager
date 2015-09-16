namespace :puppetfacts do
  desc "retrieve the facts associated with a node"
  task getfacts: :environment do
    puts "Environment : #{Rails.env}"
    for node in Node.where('certified'=>false)
      puppetfacts = nil
      if Rails.env.production?
        if File.exists? ("/var/lib/puppet/yaml/node/#{node.name}.yaml")
          puppetnode = YAML.load_file("/var/lib/puppet/yaml/node/#{node.name}.yaml")                     
          puppetfacts = puppetnode.facts.values
          puts "Mise a jour des donnees pour le noeud : #{node.name}"
          node.update_attributes(:virtual => puppetfacts["virtual"], :osarch => puppetfacts["architecture"], :osfamily => puppetfacts["kernel"], :osname => puppetfacts["operatingsystem"], :oscodename => puppetfacts["lsbdistcodename"], :osversion => puppetfacts["lsbdistrelease"], :kernel => puppetfacts["kernelrelease"])
        end
      else
        if File.exists? ("#{Rails.root}/data/node/#{node.name}.yaml")                                    
          puppetnode = YAML.load_file("#{Rails.root}/data/node/#{node.name}.yaml")                       
          puppetfacts = puppetnode.facts.values
          puts "Mise a jour des donnees pour le noeud : #{node.name}"
          node.update_attributes(:virtual => puppetfacts["virtual"], :osarch => puppetfacts["architecture"], :osfamily => puppetfacts["kernel"], :osname => puppetfacts["operatingsystem"], :oscodename => puppetfacts["lsbdistcodename"], :osversion => puppetfacts["operatingsystemrelease"], :kernel => puppetfacts["kernelrelease"])
        end
      end
    end
  end

end
