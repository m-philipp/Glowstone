
pluginList = Array.new


Dir[File.dirname(__FILE__) + 'plugins/*.rb'].each do |file|
	require File.basename(file, File.extname(file))
end


module ActionType
	OFF = 0
	ON = 1
	BLINK = 2
	PULSE = 3
	FADE_OUT = 4
	FADE_IN = 5
	FADE = 6
end


class Color
	attr_accessor :r, :b, :g
	@r = 0
	@b = 0
	@g = 0


	def initialize(red = 0, green = 0, blue = 0)
		@r = red
		@g = green 
		@b = blue
	end
end

class Action 
	attr_accessor :actionType, :color, :duration
	@actionType = ActionType::OFF
	@color = Color.new
	@duration = 0
	@priority = nil
end 

# ----------------------------------------------------- #
# Plugin File
# ----------------------------------------------------- #
class ExamplePlugin 

	attr_reader :name

	@name = "Example Plugin!"

	def update()
		return [Action.new]
	end

	def updateIntervall()
		return 100
	end
	

end

# ----------------------------------------------------- #
