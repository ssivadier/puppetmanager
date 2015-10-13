require 'yaml'
#require 'puppet'
require 'builder'

class Node < ActiveRecord::Base

  # -------------------
  #  Method: Get the list of current nodes waiting for certification
  # -------------------
  def self.puppetca_command(options = "")
    output = ""
    if Rails.env.production?
      output = `sudo puppet cert list #{options}`
    else
      output = File.read("#{Rails.root}/data/puppetca_stdout.txt")
    end
    return output
  end
  # -------------------

end
