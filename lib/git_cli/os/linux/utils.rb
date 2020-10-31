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


require 'toolrack'

require_relative '../../global'

module GitCli
  module OS
    module Linux
      module Utils
        
        def Utils.is_installed?(binary)

          if is_which_installed? 
            
            begin
              GitCli::Global.instance.logger.debug "Checking if '#{binary}' is installed..."
              res = Antrapol::ToolRack::ProcessUtilsEngine.exec("which #{binary}")
              GitCli::Global.instance.logger.debug "Yes, '#{binary}' is found in system"
              [true, res.strip]
            rescue Exception => ex 
              GitCli::Global.instance.logger.debug "No, '#{binary}' is not found in system"
              [false, ex.message]
            end

          else
            raise GitCliException, "Utility 'which' is not installed"
          end
        end # is_installed?

        private
        def Utils.is_which_installed?
          begin
            GitCli::Global.instance.logger.debug "Checking if 'which' is installed..."
            Antrapol::ToolRack::ProcessUtilsEngine.exec("which")
            GitCli::Global.instance.logger.debug "'which' utility is installed..."
            true
          rescue Exception => ex
            GitCli::Global.instance.logger.debug "'which' utility is NOT installed..."
            false
          end
        end # is_which_installed?

      end
    end
  end
end
