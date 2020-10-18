

module GitCli
  module Log

    SIMPLE_LOG_DEFAULT_CONF = {
      args: nil,          # args shall override ALL elements
      limit: "50",
      since: nil,         # log since/after this value
      until: nil,         # log until/before this value
      committed_by: nil,  # author of the commit. If given array shall be multiple
      format: "--oneline --pretty=format:\"%H | %ad | %an,%ce | %s | %b | %N\"",
    }

    def logs(opts = { })

      check_vcs

      vopts = SIMPLE_LOG_DEFAULT_CONF.merge(opts)

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "log"

      if not (vopts[:args].nil? or vopts[:args].empty?)
        cmd << vopts[:args]
      else
        cmd << "-n #{vopts[:limit]}" if not_empty?(vopts[:limit])
        cmd << "--since=#{vopts[:since]}" if not_empty?(vopts[:since])
        cmd << "--until=#{vopts[:until]}" if not_empty?(vopts[:until])
        cmd << "--committer=#{vopts[:committed_by]}" if not_empty?(vopts[:committed_by])
        cmd << vopts[:format] if not_empty?(vopts[:format])
      end

      cmdln = cmd.join(" ")
      log_debug "Logs : #{cmdln} "

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
