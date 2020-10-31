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


module GitCli
  module Clone

    include Antrapol::ToolRack::ExceptionUtils

    def clone(src, dest, opts = { }, &block)
      raise_if_empty(src, "Source to clone cannot be empty", GitCliException) 
      raise_if_empty(dest, "Destination to clone cannot be empty", GitCliException) 

      cmd = []
      cmd << exe_path
      cmd << "clone"
      cmd << src
      cmd << dest
      cmdln = cmd.join(" ")

      log_debug "Clone : #{cmdln}"

      os_exec(cmdln) do |st, res|
        [st.success?, res.strip]
      end
    end

  end
end
