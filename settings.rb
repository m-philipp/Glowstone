require 'json'

class Settings
  @pluginName  

  @settings

  def initialize(plName)
    @pluginName = plName
   
    if (!File.exist?("plugins/" + @pluginName + ".json"))
       writeDefaults()
    end
    @settings = JSON.parse(File.open("plugins/" + @pluginName + ".json").read)
  end

  def writeDefaults()
    @settings = Hash.new
    $pluginList = Array.new
    load('plugins/' + @pluginName + ".rb")
    @settings = $pluginList[0].getConfigFieldDefaults()
    @settings["priority"] = nextPriority()
    writeSettings() 
  end

  def writeSettings()
    File.open("plugins/" + @pluginName + ".json", 'w') {|f| f.write(JSON.generate(@settings)) }
  end

  def nextPriority() 
    max = 0
    Dir[File.dirname(__FILE__) + '/plugins/*.json'].each do |file|
      tmpSets = JSON.parse(File.open(file).read)
      if (max < tmpSets["priority"])
        max = tmpSets["priority"]
      end
    end
    return max + 1
  end

  def getPriority()
    return @settings["priority"]
  end

  def setPriority(prio) 
    @settings["priority"] = prio
  end

  def getSettings() 
    return @settings
  end

end
