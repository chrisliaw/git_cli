

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
