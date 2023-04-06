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
  module AddCommit

    class CommitError < StandardError; end

    def add_to_staging(*paths)
      check_vcs

      raise_if_empty(paths, "Given path to add is empty", GitCliException)

      paths = [paths] if not paths.is_a?(Array)

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "add"
      cmd.append(paths.join(" "))
      cmdln = cmd.join " "

      log_debug "Add : #{cmdln}"

      os_exec(cmdln) do |st, res|
        res.strip!
        if not st.success?
          raise CommitError, res
        else
          res
        end
        #[st.success?, res.strip]
      end
    end # add_to_staging
    alias :add :add_to_staging
    alias :add_staging :add_to_staging

    def remove_from_staging(paths)
      check_vcs

      raise_if_empty(paths, "Given path to reset is empty", GitCliException)

      paths = [paths] if not paths.is_a?(Array)

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "reset"
      cmd.append(paths)
      cmdln = cmd.join " "

      log_debug "reset : #{cmdln}"

      os_exec(cmdln) do |st, res|
        [st.success?, res.strip]
      end
       
    end # remove_from_staging
    alias :remove_staging :remove_from_staging

    def remove_from_vcs(paths)
      
      check_vcs

      raise_if_empty(paths, "Given path to remove from VCS is empty", GitCliException)

      paths = [paths] if not paths.is_a?(Array)

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "rm --cached"
      cmd.append(paths)
      cmdln = cmd.join " "

      log_debug "Remove from git version control : #{cmdln}"

      os_exec(cmdln) do |st, res|
        [st.success?, res.strip]
      end
      
    end # remove_from_vcs

    def commit(message, opts = { })
      check_vcs

      files = opts[:files] || []
      [files] if not files.is_a?(Array)
      # have to escape the message for command line purposes
      msg = message.gsub("\"","\\\"").gsub("\\","\\\\")

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "commit"
      if not_empty?(files)
        cmd << files.join(" ")
      end
      cmd << "-m"
      cmd << "\"#{msg}\""

      cmdln = cmd.join " "

      log_debug "Commit : #{cmdln}"

      os_exec(cmdln) do |st, res|
        [st.success?, res.strip!]
        #res.strip!
        #if not st.success?
        #  raise CommitError, res
        #else
        #  res
        #end
      end

    end # commit

    def commit_all(message)
      check_vcs
      
      # have to escape the message for command line purposes
      msg = message.gsub("\"","\\\"").gsub("\\","\\\\")

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "commit"
      cmd << "-am"
      cmd << "\"#{msg}\""

      cmdln = cmd.join " "

      log_debug "Commit All : #{cmdln}"

      os_exec(cmdln)  do |st, res|
        res.strip!
        if not st.success?
          raise CommitError, res
        else
          res.strip
        end
      end
     
    end # commit_all



  end
end
