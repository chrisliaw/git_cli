

module GitCli
  module Push

    def push_changes(repos, branch = "master")
      check_vcs
      check_repos
      raise_if_empty(repos, "Push to repository name cannot be empty", GitCliException)

      raise_if_false(is_repos_exist?(repos), "Given repository name '#{repos}' is not configured for this workspace", GitCliException)
      
      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "push"
      cmd << repos
      cmd << branch

      cmdln = cmd.join " "

      log_debug "Push : #{cmdln}"
      os_exec(cmdln) do |st, res|
        [st.success?, res.strip]
      end
    end
    alias :push :push_changes

    def push_tags(repos, branch = "master")
      check_vcs
      check_repos
      raise_if_empty(repos, "Push to repository name cannot be empty", GitCliException)
      
      raise_if_false(is_repos_exist?(repos), "Given repository name '#{repos}' is not configured for this workspace", GitCliException)
      
      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "push"
      cmd << repos
      cmd << branch
      cmd << "--tags"

      cmdln = cmd.join " "

      log_debug "Push tags : #{cmdln}"
      os_exec(cmdln) do |st, res|
        [st.success?, res.strip]
      end
    end



  end
end
