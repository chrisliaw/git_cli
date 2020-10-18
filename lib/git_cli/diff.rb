

module GitCli
  module Diff

    def diff
      diff_branch("","")
    end

    def diff_file_with_last_commit(file)

      diff_common({ args: "#{file}", log_tag: "Diff file compare with last commit" })
      
    end # diff_file_with_last_commit
    alias :diff_file :diff_file_with_last_commit

    # head_to_head = true == "git diff b1..b2" -> compare head-to-head of the given two branches
    def diff_branch(b1, b2, opts = { head_to_head: true })

      if not ((b1.nil? or b1.empty?) and (b2.nil? or b2.empty?))
        diff_common({ args: "#{b1}..#{b2}", log_tag: "Diff against head of two branches" })
      else
        diff_common({ args: "", log_tag: "Diff workspace with last commit" })
      end
       
    end # diff_branch

    # changes to push to repos if 'git commit -a' is run
    def diff_working_with_last_commit

      diff_common({ args: "HEAD^ HEAD", log_tag: "Diff working with last commit" })
       
    end # diff_working_with_last_commit

    # this show different for item already put inside 'git add'
    def diff_index_with_last_commit
     
      diff_common({ args: "--cached", log_tag: "Diff index (file added with 'git add') with last commit" }) 
      
    end # diff_index_with_last_commit

    def diff_common(opts = { })

      check_vcs

      cmd = []
      cmd << "cd"
      cmd << @wsPath
      cmd << "&&"
      cmd << @vcs.exe_path
      cmd << "diff"

      if not (opts[:args].nil? or opts[:args].empty?)
        cmd << opts[:args]
      end

      cmdln = cmd.join(" ")
      log_debug "#{opts[:log_tag]} : #{cmdln} "

      res = os_exec(cmdln) do |st, res|
        
        if st.success?
          [true, res.strip!]
        else
          [false, res]
        end
      end
      
    end

  end
end
