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



require 'fileutils'

require_relative 'global'

module GitCli
  module Init

    def init(path, bare = false)
      # from Core module
      gpath = exe_path 

      cmd = []
      #cmd << "cd #{File.expand_path(path)}"
      #cmd << "&&"
      cmd << gpath
      cmd << "init"
      if bare
        cmd << "--bare"
      end
      cmd << File.expand_path(path)
     
      cmdln = cmd.join(" ")

      log_debug "Init : #{cmdln} " 

      os_exec(cmdln) do |st, res|
        [st.success?, res.strip]
      end
      
    end # init

    def reset(path)
      
      raise_if_empty(path, "Path should not be empty for reset operation", GitCliException)

      if File.exist?(path)
        Dir.entries(path).each do |f|
          if f == ".git"
            log_debug ".git directory found."
            FileUtils.rm_rf(f)
            log_debug ".git directory deleted"
            break
          end
        end
      end 

    end # reset

  end
end
