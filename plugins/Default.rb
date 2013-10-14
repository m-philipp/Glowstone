p "Default plugin is getting loaded..."

require_relative '../plugin.rb'
# ----------------------------------------------------- #
# Plugin File
# ----------------------------------------------------- #
class  DefaultPlugin < Plugin


	def update()
		p "Called DefaultPlugine.update()"
		action = Action.new
		case getSettings().getSettings()["Action"]
			when "ON"
				action.actionType = [ActionType::ON]
			when "FADE IN"
				action.actionType = [ActionType::FADE_IN]
			when "FADE OUT"
				action.actionType = [ActionType::FADE_OUT]
			when "BLINK"
				action.actionType = [ActionType::BLINK]
			when "PULSE"
				action.actionType = [ActionType::PULSE]
		end
		action.color = [Color.new(getSettings().getSettings()["Color"][0], getSettings().getSettings()["Color"][1], getSettings().getSettings()["Color"][2])]
		action.duration = [getSettings().getSettings()["Update Intervall"]]
		action.repeating = 0
		return action
	end

	def updateIntervall()
		p getSettings().getSettings()["Update Intervall"]
		return getSettings().getSettings()["Update Intervall"].to_i
	end
	
	def initialize()
		@name = "Default Plugin!"
		@fileName = "Default"
		super()
	end

	def getConfigFields()
		return {"Update Intervall" => "timespan", "Enabled" => "bool", "Action" => ["ON", "FADE IN", "FADE OUT", "PULSE", "BLINK"], "Color" => "color" }
	end

	def getConfigFieldDefaults()
		return {"Update Intervall" => "10", "Enabled" => "true", "Action" => "ON", "Color" => [255,0,0]}
	end
end

$pluginList.push(DefaultPlugin.new)

# ----------------------------------------------------- #
