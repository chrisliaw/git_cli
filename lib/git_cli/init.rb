

require 'fileutils'

require_relative 'global'

module GitCli
  module Init

    def init(path)
      # from Core module
      gpath = exe_path 

      cmd = []
      #cmd << "cd #{File.expand_path(path)}"
      #cmd << "&&"
      cmd << gpath
      cmd << "init"
      cmd << File.expand_path(path)
     
      cmdln = cmd.join(" ")

      log_debug "Init : #{cmdln} " 

      os_exec(cmdln) do |st, res|
        [st.success?, res.strip]
      end
      
    end # init

    def reset(path)
      
      raise_if_empty(path, "Path should not be empty for reset operation", GitCliException)

      if File.exist?(path)
        Dir.entries(path).each do |f|
          if f == ".git"
            log_debug ".git directory found."
            FileUtils.rm_rf(f)
            log_debug ".git directory deleted"
            break
          end
        end
      end 

    end # reset

  end
end
