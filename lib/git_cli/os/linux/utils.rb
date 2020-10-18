
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
