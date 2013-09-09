p "Example plugin is getting loaded..."

require_relative '../plugin.rb'
# ----------------------------------------------------- #
# Plugin File
# ----------------------------------------------------- #
class ExamplePlugin < Plugin


	def update()
		p "Called Example.update()"
		action = Action.new
		action.actionType = [ActionType::ON, ActionType::OFF, ActionType::BLINK, ActionType::FADE_IN, ActionType::FADE_OUT, ActionType::PULSE]
		action.color = [Color.new(255,0,0), Color.new(255,0,0), Color.new(255,0,0),Color.new(0,255,0),Color.new(0,255,0),Color.new(0,0,255)]
		action.duration = [3,3,4,4,4,4]
		action.repeating = 0
		return action
	end

	def updateIntervall()
		return 30
	end
	
	def initialize()
		@name = "Example Plugin!"
		@fileName = "plugin_example"
		super()
	end

	def getConfigFields()
		return {"Update frequency" => "timespan", "Enabled" => "bool", "Username" => "text"}
	end

	def getConfigFieldDefaults()
		return {"Update frequency" => "10", "Enabled" => "true", "Username" => "Karl"}
	end
end

$pluginList.push(ExamplePlugin.new)

# ----------------------------------------------------- #
