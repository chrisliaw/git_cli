

module GitCli
  module Tags

    def all_tags

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "tag"

      cmdln = cmd.join(" ")
      log_debug "List tags : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        
        if st.success?
          [true, res.strip!]
        else
          [false, res]
        end
      end
      
    end # tags


    def all_tags_with_date

      check_vcs

      st, tags = all_tags
      if st and not_empty?(tags)
        tagDate = { }
        tags.each_line do |l|

          tt = l.strip

          cmd = []
          cmd << "cd"
          cmd << @wsPath
          cmd << "&&"
          cmd << @vcs.exe_path
          cmd << "log -1 --format=%ai"
          cmd << tt

          cmdln = cmd.join(" ")
          log_debug "Date info for tags '#{tt}' : #{cmdln}"
          res = os_exec(cmdln) do |st, res|
            if st.success?
              tagDate[tt] = res.strip!
            else
              log_error("Date info for tag '#{tt}' error : #{res.strip}")
            end
          end

        end

        [true, tagDate]
      else
        [false, {}]
      end
      
    end # tags


    def create_tag(tag)
      
      raise_if_empty(tag, "Tag name cannot be empty", GitCliException)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "tag"
      cmd << tag

      cmdln = cmd.join(" ")
      log_debug "New tag : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        if st.success?
          [true, res.strip!]
        else
          [false, res]
        end
      end

    end # create_tag

    def fetch_tag_to_local
      
      check_vcs
      check_repos

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "fetch --all --tags"

      cmdln = cmd.join(" ")
      log_debug "Fetch tags from repository : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        
        if st.success?
          [true, res.strip!]
        else
          [false, res]
        end
      end
      

    end

  end
end
