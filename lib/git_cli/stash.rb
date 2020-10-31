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
  module Stash

    # GIT Stash is interesting to facilitate keeping the WIP 
    # on specific branch but have to switch to other branch
    # due to various reason. i.e. urgent fix, hot patch etc
   
    # 
    # Save all the temporary changes so branch switch is possible
    #
    def stash_changes(msg, include_untracked = true)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "stash"
      cmd << "save"

      if not_empty?(msg)
        # have to escape the message for command line purposes
        msg2 = msg.gsub("\"","\\\"").gsub("\\","\\\\")
        cmd << msg2
      end

      # always include untracked since the stash condition
      # is played using scenario under development and must
      # switch branch for any reasons
      if include_untracked
        cmd << "--include-untracked"
      end

      cmdln = cmd.join(" ")
      log_debug "Stash changes : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        [st.success?, res]
      end

    end # stash changes

    #
    # List all saved temporary changes
    #
    def stash_list

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "stash list"

      cmdln = cmd.join(" ")
      log_debug "Stash list : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        if st.success?
          list = { }
          res.each_line do |l|
            ll = l.split(": ")

            # first element is the stash id
            # 2nd element is the info on branch
            branch = ll[1].split(" ")[-1]


            list[ll[0].strip] = [branch, ll[1..-1].join(": ")] 
          end

          [true, list]
        else
          [false, res]
        end
      end

    end # stash list

    # 
    # Restore the temporary changes
    # Regardless which branch are you in
    #
    def stash_restore(id = nil)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "stash apply"

      if not is_empty?(id)
        cmd << id
      end

      cmdln = cmd.join(" ")
      log_debug "Stash apply (restore the saved state) : #{cmdln}"
      res = os_exec(cmdln) do |st, res|

        [st.success?, res]

      end

    end # stash restore

    def stash_restore_and_remove(id = nil)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "stash pop"

      if not is_empty?(id)
        cmd << id
      end

      cmdln = cmd.join(" ")
      log_debug "Stash pop (restore the saved state and delete from list) : #{cmdln}"
      res = os_exec(cmdln) do |st, res|

        [st.success?, res]

      end

    end # stash restore

    def stash_to_new_branch(branch, id = nil)

      raise_if_empty(branch, "Branch name must not be empty for stash to branch operation", GitCliException)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "stash branch"
      cmd << branch

      if not is_empty?(id)
        cmd << id
      end

      cmdln = cmd.join(" ")
      log_debug "Stash to new branch and delete from list : #{cmdln}"
      res = os_exec(cmdln) do |st, res|

        [st.success?, res]

      end
      
    end # stash_to_branch

    def stash_clear

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "stash clear"

      cmdln = cmd.join(" ")
      log_debug "Clear the stash list (all uncommitted changes lost permanently) : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        [st.success?, res]
      end
      
    end # stash clear

    def stash_remove(id = nil)
 
      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "stash drop"
      if not is_empty?(id)
        cmd << id
      end

      cmdln = cmd.join(" ")
      log_debug "Stash #{is_empty?(id) ? "remove" : "'#{id}' is being removed"} from list (all uncommitted changes lost permanantly): #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        [st.success?, res]
      end
     
    end # stash_remove

  end
end
