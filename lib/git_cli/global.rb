# Copyright (C) 2020  Chris Liaw <chrisliaw@antrapol.com>
# Author: Chris Liaw <chrisliaw@antrapol.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


require 'tlogger'
require 'singleton'

module GitCli
  class Global
    include Singleton

    attr_reader :logger
    def initialize
      debug = ENV['GitCli_Debug']
      debugOut = ENV['GitCli_DebugOut'] || STDOUT
      if debug.nil?
        @logger = Tlogger.new('git_cli.log', 5, 1024*1024*10)
      else
        @logger = Tlogger.new(debugOut)
      end
    end

  end

  class GitCliException < StandardError; end

end
