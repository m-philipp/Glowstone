require 'sinatra'
require 'haml'

require_relative './settings'

set :port, 8080
set :bind, '0.0.0.0'



get '/' do
	r = params[:r]
	g = params[:g]
	b = params[:b]
	if(validColors(r,g,b))
		haml :index, :locals => {:r => $color[0], :g => $color[1], :b =>$color[2]}
	else
		haml :index, :locals => {:r => $color[0], :g => $color[1], :b =>$color[2]}
	end
end


# pid = spawn("ruby ./plugin.rb")
# Process.detach(pid)
# 
# Process.kill("KILL", pid)
