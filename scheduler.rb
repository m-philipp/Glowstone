
$pluginList = Array.new

$pluginActions = Hash.new
$mutex = Mutex.new

$lastActionExecution = Hash.new

$lastPluginUpdates = Hash.new

Dir[File.dirname(__FILE__) + '/plugins/*.rb'].each do |file|
	require_relative 'plugins/'+File.basename(file, File.extname(file))
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
		$mutex.synchronize{
			if Time.now.to_i - $lastActionExecution[priority] > action.repeating and action.repeating >= 0
				if(action.repeating == 0) 
					action.repeating = -1
				end
				executeAction(action)
				$lastActionExecution[priority] = Time.now.to_i
			end
		}
	}
	sleep(0.1)
	runScheduler()
end

def executeAction(a)
	# TODO implement Action execution.
	p "----------------> exectuing Action"
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
