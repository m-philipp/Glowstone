require 'sinatra'
require 'haml'

require_relative './settings'


set :port, 8080
set :bind, '0.0.0.0'



# pid = spawn("ruby ./plugin.rb")
# Process.detach(pid)
# 
# Process.kill("KILL", pid)
DEBUG = true



get '/' do
	# haml :index, :locals => {:r => $color[0], :g => $color[1], :b =>$color[2]}
	@nav = {"Home" => "#", "Plugin 1" => "plugin1"}
	@plugins = ["TestPlugin 1", "TestPlugin 2"]
	haml :index, :locals => {:nav => @nav}
end
