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
       
    end # log

    def show_log(cid)
      
      check_vcs

      raise_if_empty(cid, "Commit ID must be present for detail log discovery", GitCliException)
      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "show"
      cmd << cid

      cmdln = cmd.join(" ")
      log_debug "Show : #{cmdln}"

      res = os_exec(cmdln) do |st, res|
        
        if st.success?
          [true, res.strip!]
        else
          [false, res]
        end
      end

    end # show

  end
end
