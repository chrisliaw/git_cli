
module GitCli
  module AddCommit

    def add_to_staging(paths)
      check_vcs

      raise_if_empty(paths, "Given path to add is empty", GitCliException)

      paths = [paths] if not paths.is_a?(Array)

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "add"
      cmd.append(paths)
      cmdln = cmd.join " "

      log_debug "Add : #{cmdln}"

      os_exec(cmdln) do |st, res|
        [st.success?, res.strip]
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

    def commit(message)
      check_vcs

      # have to escape the message for command line purposes
      #msg = message.gsub("'","\\\\'").gsub("\"","\\\'").gsub("\\","\\\\")
      msg = escape_string(message)

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "commit"
      cmd << "-m"
      cmd << "\"#{msg}\""

      cmdln = cmd.join " "

      log_debug "Commit : #{cmdln}"

      os_exec(cmdln) do |st, res|
        [st.success?, res.strip]
      end

    end

    def commit_all(msg)
      check_vcs
      
      # have to escape the message for command line purposes
      #msg = message.gsub("'","\\\\'").gsub("\"","\\\'").gsub("\\","\\\\")
      msg = escape_string(message)

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "commit"
      cmd << "-am"
      cmd << msg

      cmdln = cmd.join " "

      log_debug "Commit All : #{cmdln}"

      os_exec(cmdln)  do |st, res|
        [st.success?, res.strip]
      end
     
    end

    def escape_string(msg)
      if not_empty?(msg)
        Regexp.escape(msg)
      end
    end

  end
end
