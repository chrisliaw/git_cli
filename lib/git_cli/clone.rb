
module GitCli
  module Clone

    include Antrapol::ToolRack::ExceptionUtils

    def clone(src, dest, opts = { }, &block)
      raise_if_empty(src, "Source to clone cannot be empty", GitCliException) 
      raise_if_empty(dest, "Destination to clone cannot be empty", GitCliException) 

      cmd = []
      cmd << exe_path
      cmd << "clone"
      cmd << src
      cmd << dest
      cmdln = cmd.join(" ")

      log_debug "Clone : #{cmdln}"

      os_exec(cmdln) do |st, res|
        [st.success?, res.strip]
      end
    end

  end
end
