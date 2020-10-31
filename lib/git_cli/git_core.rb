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


require_relative 'global'

module GitCli
  module GitCore

    include Antrapol::ToolRack::ConditionUtils
    #extend Antrapol::ToolRack::ConditionUtils
   
    def exe_path
      if @gitPath.nil? or @gitPath.empty?
        st, path = is_installed?
        @gitPath = path.strip if st
      end

      @gitPath
    end # exe_path

    def version
      
      if @version.nil? or @version.empty?
        path = exe_path
        cmd = "#{path} version"
        log_debug "version : #{cmd}"
        os_exec(cmd) do |st, res|
          # as current dev version
          if st.success?
            res.strip!
            # based on version 2.25.1
            @version = res.split(" ")[-1]
            [true,@version]
          else
            [false,""]
          end
        end
      else
        [true, @version]
      end

    end # version

    private
    def is_installed?

      if Antrapol::ToolRack::RuntimeUtils.on_linux?
        require_relative 'os/linux/utils'
        GitCli::Global.instance.logger.debug "Running on Linux is detected"
        st, path = GitCli::OS::Linux::Utils.is_installed?("git")
        GitCli::Global.instance.logger.debug "'git' install check return [#{st},#{path}]"

        [st, path]

      elsif Antrapol::ToolRack::RuntimeUtils.on_mac?
        GitCli::Global.instance.logger.debug "Running on MacOS is detected"
        require_relative 'os/macos/utils'

      elsif Antrapol::ToolRack::RuntimeUtils.on_window?
        GitCli::Global.instance.logger.debug "Running on MS Window is detected"
        require_relative 'os/win/utils'

      else
        GitCli::Global.instance.logger.debug "Cannot determine which OS am i running...Confused"
        raise RuntimeError, "Unknown platform"
      end

    end # is_installed?

  end
end
