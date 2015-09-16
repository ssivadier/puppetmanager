# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
PuppetManager::Application.initialize!


class Logger
  def format_message(level, time, progname, msg)
    "#{time.to_s(:db)} #{level} -- #{msg}\n"
  end
end
