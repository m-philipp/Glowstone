require 'sinatra'
require 'haml'

require_relative 'pca9685'


set :port, 8080
set :bind, '0.0.0.0'


DEBUG = true

$color = [0,0,0]


$cube = PCA9685.new(0x40, DEBUG)

# Initialize LEDs
for i in (0..15)
	$cube.setPWM(i, 0, 4095)
end


get '/' do
	r = params[:r]
	g = params[:g]
	b = params[:b]
	if(validColors(r,g,b))
		setCubeColor()
		haml :index, :locals => {:r => $color[0], :g => $color[1], :b =>$color[2]}
	else
		haml :index, :locals => {:r => $color[0], :g => $color[1], :b =>$color[2]}
	end
end



def validColors(r,g,b)
	if(r != nil && g != nil && b != nil)
		r = r.to_i()
		g = g.to_i()
		b = b.to_i()
		if((0..255).member?(r) && (0..255).member?(g) && (0..255).member?(b))
			$color = [r,g,b]
			return true
		end
	end
	return false
end

def setCubeColor()
	r = (255 - $color[0])*16 + 15
	g = (255 - $color[1])*16 + 15
	b = (255 - $color[2])*16 + 15
	
	if DEBUG
		p r
		p g
		p b
	end

	$cube.setPWM(0, 0, r)
	$cube.setPWM(1, 0, g)
	$cube.setPWM(2, 0, b)
	
	$cube.setPWM(4, 0, r)
	$cube.setPWM(5, 0, g)
	$cube.setPWM(6, 0, b)

	$cube.setPWM(8, 0, r)
	$cube.setPWM(9, 0, g)
	$cube.setPWM(10, 0, b)

	$cube.setPWM(12, 0, r)
	$cube.setPWM(13, 0, g)
	$cube.setPWM(14, 0, b)
end
