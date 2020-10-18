

module GitCli
  module Ignore

    def ignore(val)
      with_ignore_file do |f|
        f.puts val
      end 
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
