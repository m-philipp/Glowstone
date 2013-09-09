p "Example plugin is getting loaded..."

# ----------------------------------------------------- #
# Plugin File
# ----------------------------------------------------- #
class ExamplePlugin 

	attr_reader :name

	@name

	def update(parameters)
		p "Called Example.update()"
		action = Action.new
		action.actionType = [ActionType::FADE_IN, ActionType::FADE_OUT]
		action.color = [Color.new(255,0,0), Color.new(255,0,0)]
		action.duration = [0.2, 0.2]
		action.repeating = 10
		return action
	end

	def updateIntervall()
		return 2
	end
	
	def initialize()
		@name = "Example Plugin!"
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
