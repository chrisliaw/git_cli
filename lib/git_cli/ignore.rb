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
  module Ignore

    def ignore(val)
      with_ignore_file do |f|
        f.puts val
      end 
      log_debug ".gitignore file updated with line '#{val}'"
      [true,".gitignore file updated"]
    end

    def ignore_rules
      st, root = workspace_root
      root.strip!
      if st
        rulesFile = File.join(root,".gitignore")
        if File.exist?(rulesFile)
          File.open(rulesFile,"r") do |f|
            @cont = f.read
          end
          @cont
        else
          ""
        end
      else
        ""
      end
    end

    def update_ignore_rules(rules)
      st, root = workspace_root
      root.strip!
      if st
        rulesFile = File.join(root,".gitignore")
        File.open(rulesFile,"w") do |f|
          f.write rules
        end
      end
      log_debug ".gitignore files is updated!"
      [true,".gitignore file is updated"]
    end

    private
    def with_ignore_file(&block)
      if block
        st, root = workspace_root
        root.strip!
        if st
          igPath = File.join(root,".gitignore")
          FileUtils.touch(igPath) if not File.exist?(igPath)
          File.open(igPath,"a") do |f|
            block.call(f)
          end
        else
          raise GitCliException, "Cannot get workspace root. Probably not a GIT workspace?"
        end
      end
    end

  end
end
