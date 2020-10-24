

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
