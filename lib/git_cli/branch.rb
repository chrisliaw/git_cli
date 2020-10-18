

module GitCli
  module Branch

    def current_branch

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      # only works from git version 2.22 onwards
      # Shall return just the name of the branch
      cmd << "branch --show-current"
      # another way but shall return like refs/heads/master
      #cmd << "symbolic-ref HEAD"

      cmdln = cmd.join(" ")
      log_debug "Current branch : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        
        if st.success?

          # this is for command 'git branch'
          # But for newly created workspace, git branch will give empty string
          #res.each_line do |l|
          #  tok = l.split " "
          #  if tok[0] == "*"
          #    @currBranch = tok[1].strip
          #    break
          #  end
          #end

          [true, res.strip!]
        else
          [false, res]
        end
      end
      
    end # current_branch

    def all_branches
      br = []
      st, lb = local_branches
      if st
        br.concat(lb)
      end

      st, rb = remote_branches
      if st
        br.concat(rb)
      end

      [true, br]
       
    end # all_branches

    def local_branches

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "branch"

      cmdln = cmd.join(" ")
      log_debug "Local branch : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        
        if st.success?
          b = []
          res.strip!
          res.each_line do |l|
            b << l.strip
          end
          [true, b]
        else
          [false, res]
        end
      end
       
    end # local_branches

    def remote_branches

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "branch -r"

      cmdln = cmd.join(" ")
      log_debug "Remote branch : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        
        if st.success?
          b = []
          res.strip!
          res.each_line do |l|
            b << l.strip
          end
          
          [true, b]
        else
          [false, res]
        end
      end
      
    end # remote_branches

    def switch_branch(branch)
      
      raise_if_empty(branch, "Branch name cannot be empty", GitCliException)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "checkout"
      cmd << branch

      cmdln = cmd.join(" ")
      log_debug "Switch branch : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        if st.success?
          [true, res.strip]
        else
          [false, res]
        end
      end

    end

    def create_branch(branch)

      raise_if_empty(branch, "Branch name cannot be empty", GitCliException)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "branch"
      cmd << branch

      cmdln = cmd.join(" ")
      log_debug "Create branch : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        
        if st.success?
          [true, res.strip]
        else
          [false, res]
        end
      end
      
    end

  end
end
