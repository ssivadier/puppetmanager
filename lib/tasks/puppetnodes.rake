namespace :puppetnodes do
  desc "Fetch certified nodes in puppet"
  task :import => :environment do
    puts "Environment : #{Rails.env}"
    output_command = Node.puppetca_command('--all')
    unless output_command.blank?
      @nodes = output_command.split(/\n/).map do | line |
        name = line.split(/\s+/)[1].gsub(/"/,'')    # Get the fqdn
        Node.where('name'=>name).first_or_create    # Checks if the node already exists, or creates it.
      end
    end
  end
end
