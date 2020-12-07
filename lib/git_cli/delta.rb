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
  module Delta

    def status
      
      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "status"

      cmdln = cmd.join(" ")
      log_debug "Status : #{cmdln}"
      res = os_exec(cmdln) do |st, res|

        if st.success?
          [true, res]
        else
          [false, res]
        end
      end
      
    end # status

    def modified_files
      
      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      # list only non staged modifications
      cmd << "diff --name-only --diff-filter=M"

      cmdln = cmd.join(" ")
      log_debug "Modified files : #{cmdln}"
      dirs = []
      files = []
      res = os_exec(cmdln) do |st, res|

        if st.success?
          res.each_line do |l|
            l.chomp!
            if File.directory?(File.join(@wsPath,l))
              dirs << l	
            else
              files << l
            end
          end

          [true, dirs.sort, files.sort]
        else
          [false, [], []]
        end

      end
    end # modified files

    def conflicted_files
      
      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "diff --name-only --diff-filter=U"

      cmdln = cmd.join(" ")
      log_debug "Conflicted files : #{cmdln}"
      dirs = []
      files = []
      res = os_exec(cmdln) do |st, res|

        if st.success?
          res.each_line do |l|
            l.chomp!
            if File.directory?(File.join(@wsPath,l))
              dirs << l	
            else
              files << l
            end
          end

          [true, dirs.sort, files.sort]
        else
          [false, [], []]
        end

      end
    end # conflicted files

    def new_files
      
      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "ls-files --others --exclude-standard --directory"

      cmdln = cmd.join(" ")
      log_debug "New Files : #{cmdln}"
      dirs = []
      files = []
      res = os_exec(cmdln) do |st, res|

        if st.success?
          res.each_line do |l|
            l.chomp!
            if File.directory?(File.join(@wsPath,l))
              dirs << l	
            else
              files << l
            end
          end

          [true, dirs.sort, files.sort]
        else
          [false, [], []]
        end
      end

    end # new_files

    def deleted_files
      
      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "ls-files -d"

      cmdln = cmd.join(" ")
      log_debug "Deleted files : #{cmdln}"
      dirs = []
      files = []
      res = os_exec(cmdln) do |st, res|

        if st.success?
          res.each_line do |l|
            l.chomp!
            if File.directory?(File.join(@wsPath,l))
              dirs << l	
            else
              files << l
            end
          end

          [true, dirs.sort, files.sort]
        else
          [false, [], []]
        end
      end
     
    end # deleted_files

    def staged_files
      
      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "diff --name-only --cached"

      cmdln = cmd.join(" ")
      log_debug "New Files : #{cmdln}"
      dirs = []
      files = []
      res = os_exec(cmdln) do |st, res|

        if st.success?
          res.each_line do |l|
            l.chomp!
            if File.directory?(File.join(@wsPath,l))
              dirs << l	
            else
              files << l
            end
          end

          [true, dirs.sort, files.sort]
        else
          [false, [], []]
        end
      end

    end # staged_files

    def reset_file_changes(path)

      raise_if_empty(path, "Path cannot be empty for reset file changes operation", GitCliException)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "checkout --"
      cmd << path

      cmdln = cmd.join(" ")
      log_debug "Reset file changes local changes (given file permanent) : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        [st.success?, res]
      end
      
    end # reset file changes

    def reset_all_changes

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "reset --hard"

      cmdln = cmd.join(" ")
      log_debug "Reset all local changes (permanent) : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        [st.success?, res]
      end
      
    end # reset all changes


  end
end
