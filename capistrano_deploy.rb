# capistrano_deploy.rb - 07/17/2008 Marc Adams (marc@gamelayers.com)
#
# This is a cruisecontrol.rb plugin to execute a deploy via capistrano if the build succeeds.
# You need to add the following to the project configuration to hook it in:
#     project.capistrano_deploy.server = "cruise"
# Where "cruise" is the name of your deployment if using multiple stage deployments.
class CapistranoDeploy
  attr_accessor :server

  # Called when cruisecontrol starts and loads the plugin
  def initialize(project = nil)
    @server = ""
    @project = project
  end

  # Runs when a build is finished (checkout, tests etc;)
  def build_finished(build)
    # If server isn't defined or the build fails
    return if @server.empty? or build.failed?
    # Otherwise run the command to deploy the code to the supplied server.
    CommandLine.execute "cd #{@project.path}/work && cap #{@server} deploy:long"
  rescue Exception
    build.fail!("Couldn't deploy via cruisecontrol")
  end
end

end

Project.plugin :capistrano_deploy