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
  module Delta

    class GitDeltaError < StandardError; end
    class VCSItem
      attr_reader :path, :full, :type
      def initialize(type, path, full)
        @type = type
        @path = path
        @full = full
      end

      # support sort
      def <=>(val)
        @path <=> val.path 
      end
    end
    class NewDir < VCSItem
      def initialize(path, full)
        super(:dir, path, full)
      end
      def to_s
        "[N] #{@path}"
      end
    end
    class NewFile < VCSItem
      def initialize(path, full)
        super(:file, path, full)
      end
      def to_s
        "[N] #{@path}"
      end
    end
    class ModifiedDir < VCSItem
      def initialize(path, full)
        super(:dir, path, full)
      end
      def to_s
        "[M] #{@path}"
      end
    end
    class ModifiedFile < VCSItem
      def initialize(path, full)
        super(:file, path, full)
      end
      def to_s
        "[M] #{@path}"
      end
    end
    class DeletedDir < VCSItem
      def initialize(path, full)
        super(:dir, path, full)
      end
      def to_s
        "[D] #{@path}"
      end
    end
    class DeletedFile < VCSItem
      def initialize(path, full)
        super(:file, path, full)
      end
      def to_s
        "[D] #{@path}"
      end
    end
    class StagedDir < VCSItem
      def initialize(path, full)
        super(:dir, path, full)
      end
      def to_s
        "[S] #{@path}"
      end
    end
    class StagedFile < VCSItem
      def initialize(path, full)
        super(:file, path, full)
      end
      def to_s
        "[S] #{@path}"
      end
    end
    class ConflictedDir < VCSItem
      def initialize(path, full)
        super(:dir, path, full)
      end
      def to_s
        "[C] #{@path}"
      end
    end
    class ConflictedFile < VCSItem
      def initialize(path, full)
        super(:file, path, full)
      end
      def to_s
        "[C] #{@path}"
      end
    end


    def status
      
      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "status"

      cmdln = cmd.join(" ")
      log_debug "Status : #{cmdln}"
      res = os_exec(cmdln) do |st, res|

        if not st.success?
          raise GitDeltaError, res
        else
          res
        end
        #if st.success?
        #  [true, res]
        #else
        #  [false, res]
        #end
      end
      
    end # status

    def modified_files
      
      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      # list only non staged modifications
      cmd << "diff --name-only --diff-filter=M"

      cmdln = cmd.join(" ")
      log_debug "Modified files : #{cmdln}"
      dirs = []
      files = []
      res = os_exec(cmdln) do |st, res|

        if not st.success?
          raise GitDeltaError, res
        else
          res.each_line do |l|
            l.chomp!
            full = File.join(@wsPath,l)
            if File.directory?(full)
              dirs << ModifiedDir.new(l,full)	
            else
              files << ModifiedFile.new(l,full)
            end
          end

          #[true, dirs.sort, files.sort]
          [dirs.sort, files.sort]
        end

      end
    end # modified files

    def conflicted_files
      
      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "diff --name-only --diff-filter=U"

      cmdln = cmd.join(" ")
      log_debug "Conflicted files : #{cmdln}"
      dirs = []
      files = []
      res = os_exec(cmdln) do |st, res|

        if not st.success?
          raise GitDeltaError, res
        else
          res.each_line do |l|
            l.chomp!
            full = File.join(@wsPath,l)
            if File.directory?(full)
              dirs << ConflictedDir.new(l, full)	
            else
              files << ConflictedFile.new(l, full)
            end
          end

          [dirs.sort, files.sort]
        end

      end
    end # conflicted files

    def new_files
      
      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "ls-files --others --exclude-standard --directory"

      cmdln = cmd.join(" ")
      log_debug "New Files : #{cmdln}"
      dirs = []
      files = []
      res = os_exec(cmdln) do |st, res|

        if not st.success?
          raise GitDeltaError, res
        else
          res.each_line do |l|
            l.chomp!
            full = File.join(@wsPath,l)
            if File.directory?(full)
              dirs << NewDir.new(l,full)
            else
              files << NewFile.new(l,full)
            end
          end

          [dirs.sort, files.sort]
        end
      end

    end # new_files

    def deleted_files
      
      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "ls-files -d"

      cmdln = cmd.join(" ")
      log_debug "Deleted files : #{cmdln}"
      dirs = []
      files = []
      res = os_exec(cmdln) do |st, res|

        if not st.success?
          raise GitDeltaError, res
        else
          res.each_line do |l|
            l.chomp!
            full = File.join(@wsPath,l)
            if File.directory?(full)
              dirs << DeletedDir.new(l,full)	
            else
              files << DeletedFile.new(l,full)
            end
          end

          [dirs.sort, files.sort]
        end
      end
     
    end # deleted_files

    def staged_files
      
      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "diff --name-only --cached"

      cmdln = cmd.join(" ")
      log_debug "Staged Files : #{cmdln}"
      dirs = []
      files = []
      res = os_exec(cmdln) do |st, res|

        if not st.success?
          raise GitDeltaError, res
        else
          res.each_line do |l|
            l.chomp!
            full = File.join(@wsPath,l)
            if File.directory?(full)
              dirs << StagedDir.new(l,full)	
            else
              files << StagedFile.new(l,full)
            end
          end

          [dirs.sort, files.sort]
        end
      end

    end # staged_files

    def reset_file_changes(path)

      raise_if_empty(path, "Path cannot be empty for reset file changes operation", GitDeltaError)

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "checkout --"
      cmd << path

      cmdln = cmd.join(" ")
      log_debug "Reset file changes local changes (given file permanent) : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        [st.success?, res]
      end
      
    end # reset file changes

    def reset_all_changes

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "reset --hard"

      cmdln = cmd.join(" ")
      log_debug "Reset all local changes (permanent) : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        [st.success?, res]
      end
      
    end # reset all changes

    # If remote is ahead of local
    # git rev-list HEAD..origin/main --count
    #
    # if local is ahead of remote
    # git rev-list origin/main..HEAD --count
    #
    def calculate_distance(from, to) 

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "rev-list #{from}..#{to} --count"

      cmdln = cmd.join(" ")
      log_debug "Calculate distance between two repos : #{cmdln}"
      res = os_exec(cmdln) do |st, res|
        [st.success?, res]
      end
      
    end

    def is_local_ahead_of_remote?(remote_name, branch = "main")
      
      calculate_distance("#{remote_name}/#{branch}", "HEAD")

    end

    def is_remote_ahead_of_local?(remote_name, branch = "main")
      
      calculate_distance("HEAD","#{remote_name}/#{branch}")
    end

  end
end
