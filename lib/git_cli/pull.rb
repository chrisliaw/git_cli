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
  module Pull

    def pull(repos, branch = "master")
      check_vcs
      #check_repos
      raise_if_empty(repos, "Pull from repository name cannot be empty", GitCliException)

      raise_if_false(is_repos_exist?(repos), "Given repository name '#{repos}' is not configured for this workspace", GitCliException)
      
      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "pull"
      cmd << repos
      cmd << branch

      cmdln = cmd.join " "

      log_debug "Pull : #{cmdln}"
      os_exec(cmdln) do |st, res|
        [st.success?, res.strip]
      end
      
    end

  end
end
