class MyLog
  def self.debug(message=nil)
    @my_log ||= Logger.new("#{Rails.root}/log/trace.log")
    @my_log.debug(message) unless message.nil?
  end
  def self.info(message=nil)
    @my_log ||= Logger.new("#{Rails.root}/log/trace.log")
    @my_log.info(message) unless message.nil?
  end
end
