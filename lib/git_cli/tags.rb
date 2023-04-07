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
  module Tags

    class TagError < StandardError; end

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
          res.strip.each_line.to_a.map { |v| v.strip }
          #[true, res.strip!]
        else
          raise TagError, res
          #[false, res]
        end
      end
      
    end # tags


    def tag_info(tag, format = "%H|%ad|%an|%s")

      raise_if_empty(tag, "Tag name cannot be empty", GitCliException)

      check_vcs

      tagInfo = { }

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      #cmd << "log -1 --format=%ai"
      cmd << "show"
      cmd << tag

      # git show <tag> with format
      # doesn't really portray the actual date
      # the creation of tag in history commit list
      # the date is refers to the commit date,
      # not the date the tag was created
      if not_empty?(format)
        cmd << "--format=\"#{format}\""
      end

      cmdln = cmd.join(" ")
      log_debug "Tag '#{tag}' with info : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        [st.success?, res]
      end

    end # tags

    #def all_tags_with_info(format = "%(refname:short)|%(authordate)|%(authorname)|%(subject)", deli = "|")

    #  check_vcs

    #  tagInfo = []

    #  cmd = []
    #  cmd << "cd"
    #  cmd << @wsPath
    #  cmd << "&&"
    #  cmd << @vcs.exe_path
    #  cmd << "tag"
    #  cmd << "--format=\"#{format}\""

    #  cmdln = cmd.join(" ")
    #  log_debug "All tags with info : #{cmdln}"
    #  res = os_exec(cmdln) do |st, res|
    #    if st.success?
    #      res.each_line do |l|
    #        tagInfo << l.split(deli)
    #      end
    #    else
    #      log_error("Date info for tag '#{tt}' error : #{res.strip}")
    #    end
    #  end

    #  [true, tagInfo]

    #end # tags


    def create_tag(tag, msg = nil, branch= nil)
      
      raise_if_empty(tag, "Tag name cannot be empty", GitCliException)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "tag"

      if not_empty?(msg)

        msg2 = msg.gsub("\"","\\\"").gsub("\\","\\\\")

        cmd << "-a"
        #cmd << "\"#{tag}\""
        cmd << tag
        cmd << "-m"
        cmd << "\"#{msg2}\""

      else
        cmd << tag
      end

      if not_empty?(branch)
        cmd << branch
      end

      cmdln = cmd.join(" ")
      log_debug "New tag : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        if st.success?
          #[true, res.strip!]
          res.strip
        else
          raise TagError, res
          #[false, res]
        end
      end

    end # create_tag

    def create_tag_from_commit(tag, commit, msg = nil)

      raise_if_empty(tag, "Tag name cannot be empty", GitCliException)
      raise_if_empty(commit, "Commit ID cannot be empty", GitCliException)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "tag"

      if not_empty?(msg)

        msg2 = msg.gsub("\"","\\\"").gsub("\\","\\\\")

        cmd << "-a"
        cmd << tag
        cmd << "-m"
        cmd << msg2

      else
        cmd << "-a"
        cmd << tag
      end

      cmd << commit

      cmdln = cmd.join(" ")
      log_debug "New tag from commit ID : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        if st.success?
          res.strip
          #[true, res.strip!]
        else
          raise TagError, res
          #[false, res]
        end
      end
      
    end # create_tag_from_commit

    def fetch_tag_to_local
      
      check_vcs
      #check_repos

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
          #[true, res.strip!]
          res.strip
        else
          raise TagError, res
          #[false, res]
        end
      end
      
    end # fetch_tag_to_local

    def show_tag_detail(tag, format = nil)

      raise_if_empty(tag, "Tag name cannot be empty", GitCliException)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "show"
      cmd << tag

      if not_empty?(format)
        cmd << "--format=\"#{format}\""
      end

      cmdln = cmd.join(" ")
      log_debug "Show tag '#{tag}' #{not_empty?(format) ? "[#{format}]" : ""} : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        if st.success?
          res.strip
          #[true, res.strip!]
        else
          raise TagError, res
          #[false, res]
        end
      end
      
    end # show_tag_detail

    def delete_tag(tag)
      raise_if_empty(tag, "Tag name cannot be empty", GitCliException)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "tag -d"
      cmd << tag

      cmdln = cmd.join(" ")
      log_debug "Delete tag '#{tag}' : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        if st.success?
          res.strip
          #[true, res.strip!]
        else
          raise TagError, res
          #[false, res]
        end
      end
      
    end # delete_tag

    def delete_remote_tag(repos,tag)

      raise_if_empty(repos, "Repos name cannot be empty", GitCliException)
      raise_if_empty(tag, "Tag name cannot be empty", GitCliException)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "push"
      cmd << repos
      cmd << "--delete"
      #cmd << "push origin --delete"
      cmd << tag

      cmdln = cmd.join(" ")
      log_debug "Delete remote tag '#{tag}' at '#{repos}': #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        if st.success?
          res
          #[true, res.strip!]
        else
          raise TagError, res
          #[false, res]
        end
      end
      
    end # delete_remote_tag

    def checkout_tag(tag, branch)
      
      raise_if_empty(tag, "Tag name cannot be empty", GitCliException)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "checkout"
      cmd << "tags/#{tag}"
      cmd << "-b"
      cmd << branch

      cmdln = cmd.join(" ")
      log_debug "Checkout tag '#{tag}' into branch '#{branch}': #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        if st.success?
          res.strip
          #[true, res.strip!]
        else
          raise TagError, res
          #[false, res]
        end
      end
      
    end # checkout_tag

    def tag_points_at?(dest = "HEAD")
      
      #raise_if_empty(tag, "Tag name cannot be empty", GitCliException)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "tag"
      cmd << "--points-at"
      cmd << dest

      cmdln = cmd.join(" ")
      log_debug "Check if current tag is pointing to #{dest}"
      res = os_exec(cmdln) do |st, res|
        if st.success?
          not_empty?(res.strip)
        else
          raise TagError, res
        end
      end
      
    end # is_tag_points_at?

  end
end
