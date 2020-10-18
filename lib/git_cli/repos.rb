

module GitCli
  module Repos

    def remote_config
      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "remote -vv"

      cmdln = cmd.join(" ")
      log_debug "Remote config : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        
        if st.success?

          remotes = { }
          res.each_line do |l|
            ls = l.split("\t")
            lss = ls[1].split(" ")
            if not remotes.keys.include?(ls[0])
              remotes[ls[0]] = lss[0]
            end
          end

          [true, remotes]
        else
          [false, res]
        end
      end
      
    end # remote_config

    def add_remote(name, url)
    
      raise_if_empty(name, "Remote name cannot be empty to add", GitCliException)
      raise_if_empty(url, "Remote URL cannot be empty to add", GitCliException)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "remote"
      cmd << "add"
      cmd << name
      cmd << url

      cmdln = cmd.join(" ")
      log_debug "Add remote config : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        
        if st.success?
          [true, res.strip]
        else
          [false, res.strip]
        end
      end


    end # add_remote

    def remove_remote(name)
    
      raise_if_empty(name, "Remote name cannot be empty to remove", GitCliException)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "remote"
      cmd << "remove"
      cmd << name

      cmdln = cmd.join(" ")
      log_debug "Remove remote config : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        
        if st.success?
          [true, res.strip]
        else
          [false, res.strip]
        end
      end

    end # remove_remote


 
  end
end
