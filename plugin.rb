class Plugin
  attr_accessor :fileName, :name
  attr_reader :settings

  @fileName
  @name

  def initialize()
  end

	def getSettings()
		require_relative "settings.rb"
		return Settings.new(@fileName)
	end

end
