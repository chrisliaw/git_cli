
require 'tlogger'
require 'singleton'

module GitCli
  class Global
    include Singleton

    attr_reader :logger
    def initialize
      @logger = Tlogger.new
    end
  end

  class GitCliException < StandardError; end

end
