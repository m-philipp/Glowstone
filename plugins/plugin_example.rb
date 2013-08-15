p "Example plugin is getting loaded..."

# ----------------------------------------------------- #
# Plugin File
# ----------------------------------------------------- #
class ExamplePlugin 

	attr_reader :name

	@name

	def update(parameters)
		return [Action.new]
	end

	def updateIntervall()
		return 100
	end
	
	def initialize()
		@name = "Example Plugin!"
	end

	def getConfigFields()
		return {"Update frequency" => "timespan", "Enabled" => "bool", "Username" => "text"}
	end
end

$pluginList.push(ExamplePlugin.new)

# ----------------------------------------------------- #
