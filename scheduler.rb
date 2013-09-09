require_relative 'pca9685'

DEBUG = false

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

	def multiply(factor)
		return Color.new((@r*factor).to_i, (@g*factor).to_i, (@b*factor).to_i)
	end
end

class Action 
	attr_accessor :actionType, :color, :duration, :priority, :repeating
	@actionType = Array.new
	@color = Array.new
	@duration = Array.new

	# repeating > 0  => repeat all repeating seconds
	# repeating == 0 => execute once
	# repeating < 0  => don't execute
	@repeating = -1
	
	@priority = nil
end


def setCubeColor()
        r = (255 - $color.r)*16 + 15
        g = (255 - $color.g)*16 + 15
        b = (255 - $color.b)*16 + 15

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


$pluginList = Array.new

$pluginActions = Hash.new
$mutex = Mutex.new

$lastActionExecution = Hash.new

$lastPluginUpdates = Hash.new

Dir[File.dirname(__FILE__) + '/plugins/*.rb'].each do |file|
	require_relative 'plugins/'+File.basename(file, File.extname(file))
end

$cube = PCA9685.new(0x40, DEBUG)

$color = Color.new(0,0,0)
trace_var :$color, proc{setCubeColor()}



# Initialize LEDs
for i in (0..15)
 	$cube.setPWM(i, 0, 4095)
end


def collectActions()
	p "collecting Actions"
	$pluginList.each do |plugin|
		if(Time.now.to_i - $lastPluginUpdates[getPriority(plugin)] > plugin.updateIntervall())
			run = true
			timer = Time.now.to_i
			updater = Thread.new{
				action = plugin.update()
				$mutex.synchronize{
					$pluginActions[getPriority(plugin)] = action
				}
				$lastPluginUpdates[getPriority(plugin)] = Time.now.to_i
				run = false
			}
			while(run)
				sleep(0.1)
				if (Time.now.to_i - timer > 5)
					Thread.kill(updater)
					p "Plugin update timedout and was killed"
					break
				end
			end
		end
	end
	sleep(0.1)
	collectActions()
end

	

def getPriority(plugin)
	return plugin.getSettings().getPriority()
end

def runScheduler()
	p "running Scheduler"
	$pluginActions.each { |priority, action|
			if Time.now.to_i - $lastActionExecution[priority] > action.repeating and action.repeating >= 0
				if(action.repeating == 0) 
					action.repeating = -1
				end
				executeAction(action)
				$lastActionExecution[priority] = Time.now.to_i
			end
	}
	sleep(0.1)
	runScheduler()
end

def executeAction(a)
	# TODO implement Action execution.
	p "----------------> exectuing Action"
	i = 0
	a.actionType.each do |type|
		p type
		case type
			when ActionType::OFF
				$color = Color.new(0,0,0)
				sleep(a.duration[i])
			when ActionType::ON
				p "setting color to " + a.color[i].to_s
				$color = a.color[i]
				sleep(a.duration[i])
			when ActionType::BLINK
				doBlink(a.color[i], a.duration[i])
			when ActionType::FADE_IN
				doFadeIn(a.color[i], a.duration[i])
			when ActionType::FADE_OUT
				doFadeIn(a.color[i], a.duration[i],1)
			when ActionType::PULSE
				doPulse(a.color[i], a.duration[i])
			else
				p "not implemented action!"
		end
		i += 1
	end
end

def doBlink(color, duration)
	for i in 1..duration
		$color = color
		sleep(0.5)
		$color = Color.new(0,0,0)
		sleep(0.5)
	end		
end

def doFadeIn(color, duration,direction=0)
	start = Time.now.to_f
	while(Time.now.to_f-start < duration)
		factor = (Time.now.to_f-start)/duration
/bin/bash: scheduler.rb: command not found
		p factor
		$color = color.multiply(factor)
		sleep(0.05)
	end
end

def doFade()
	# TODO
end

def doPulse(color, duration)
	for i in 1..duration
		doFadeIn(color, 0.5)
		doFadeIn(color,0.5,1)
	end		
end




# -------------------------------------------------------- #
# Initialize Arrays and start Threads.
# -------------------------------------------------------- #

$pluginList.each do |plugin|
	$lastActionExecution[getPriority(plugin)] = 0
	$lastPluginUpdates[getPriority(plugin)] = 0
end

collecter = Thread.new{collectActions()}
scheduler = Thread.new{runScheduler()}

# while true can be removed if sinatra keeps running.
while(true)
	sleep(0.001)
end

# -------------------------------------------------------- #
