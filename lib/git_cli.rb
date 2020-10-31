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

require "git_cli/version"

require 'toolrack'

require_relative "git_cli/git_core"
require_relative "git_cli/init"
require_relative "git_cli/clone"
require_relative "git_cli/add_commit"
require_relative "git_cli/delta"
require_relative "git_cli/push"
require_relative "git_cli/pull"
require_relative "git_cli/branch"
require_relative "git_cli/diff"
require_relative "git_cli/ignore"
require_relative "git_cli/log"
require_relative "git_cli/tags"
require_relative "git_cli/repos"
require_relative "git_cli/stash"


module GitCli
  class Error < StandardError; end
  # Your code goes here...

  MIN_GIT_VERSION = "2.22"

  module Common
    include Antrapol::ToolRack::ConditionUtils
    include Antrapol::ToolRack::ExceptionUtils

    def os_exec(path, &block)
      # redirect stderr to stdout
      path = "#{path} 2>&1"
      res = Antrapol::ToolRack::ProcessUtilsEngine.exec(path)
      if block
        # $?.exitstatus => error codes
        # $?.success? => true / false
        # $?.pid => child PID
        block.call($?, res)
      else
        res.strip
      end
    end

    def log_debug(str)
      GitCli::Global.instance.logger.debug(str)
    end

    def log_error(str)
      GitCli::Global.instance.logger.error(str)
    end

    def log_warn(str)
      GitCli::Global.instance.logger.warn(str)
    end
  end # common operations

  class Gvcs::Vcs
    include GitCli::Common
    include GitCli::GitCore
    include GitCli::Init
    include GitCli::Clone
    
    def initialize
      # version check
      vst, tver = version
      if vst
        if (tver <=> MIN_GIT_VERSION) == -1
          log_warn("Min required version of GIT is #{MIN_GIT_VERSION}. System installed GIT is version #{tver}. The output might not be correct.") 
        end

        log_debug "System GIT version is #{tver}. Min require version is #{MIN_GIT_VERSION}"
      end
      
    end
  end

  module WsCommon
    def check_vcs
      raise_if_empty(@vcs, "VCS must not be null", GitCliException)
      raise_if_empty(@wsPath, "Workspace path must not be null", GitCliException)
    end

    def check_repos
      raise_if_empty(@repos, "Repository must not be null", GitCliException)
    end
  end # WsCommon

  class Gvcs::Workspace
    include GitCli::Common
    include WsCommon
    include GitCli::AddCommit
    include GitCli::Delta
    include GitCli::Push
    include GitCli::Pull
    include GitCli::Branch
    include GitCli::Diff
    include GitCli::Ignore
    include GitCli::Log
    include GitCli::Tags
    include GitCli::Repos
    include GitCli::Stash

    attr_accessor :repos
    def initialize(vcs, path)

      raise_if_empty(vcs , "VCS cannot be empty", GitCliException)
      raise_if_empty(path, "Workspace path cannot be empty", GitCliException)
      
      @vcs = vcs
      @givenPath = path

      @wsPath = File.expand_path(@givenPath)

      @repos = []

    end # initialize

    def path
      @wsPath
    end

    def vcs
      @vcs
    end

    def add_repos(repos)
      @repos << repos if not repos.nil?
    end # add_repos

    def check_repos
      raise_if_empty(@repos, "Repositories should not be empty", GitCliException)
    end # check_repos

    def is_repos_exist?(name)
      found = false
      @repos.each do |re|
        if re.name == name
          found = true
          break
        end
      end
      found
    end # is_repos_exist?

    def is_workspace?
      st, res = status
      st 
    end

    def workspace_root

      if (@wsRoot.nil? or (@wsRoot[0] == false))

        check_vcs

        cmd = []
        cmd << "cd"
        cmd << @wsPath
        cmd << "&&"
        cmd << @vcs.exe_path
        cmd << "rev-parse --show-toplevel"

        cmdln = cmd.join(" ")
        log_debug "Workspace root: #{cmdln}"
        res = os_exec(cmdln) do |st, res|

          if st.success?
            @wsRoot = [true, res]
          else
            @wsRoot = [false, res]
          end
        end

      end

      @wsRoot
      
    end # workspace_root

  end # Gvcs::Workspace


  class Gvcs::Repository
    
    attr_reader :sslVerify
    attr_reader :name, :url
    #attr_accessor :branches
    def initialize(name, url) #, branches = [])
      @name = name
      @url = url
      #@branches = branches
      @sslVerify = true  
    end

    def ssl_verify(bool)
      @sslVerify = bool
    end

  end # repository

end
