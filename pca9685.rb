# need 'i2c' gem installed
require 'i2c/i2c'

class PCA9685
  PCA9685_SUBADR1		= 0x02
  PCA9685_SUBADR2		= 0x03
  PCA9685_SUBADR3		= 0x04
  PCA9685_MODE1			= 0x00
  PCA9685_PRESCALE		= 0xFE
  PCA9685_LED0_ON_L		= 0x06
  PCA9685_LED0_ON_H		= 0x07
  PCA9685_LED0_OFF_L	= 0x08
  PCA9685_LED0_OFF_H	= 0x09
  PCA9685_ALLLED_ON_L	= 0xFA
  PCA9685_ALLLED_ON_H	= 0xFB
  PCA9685_ALLLED_OFF_L	= 0xFC
  PCA9685_ALLLED_OFF_H	= 0xFD

  def initialize(address=0x40, debug = false)
    @address = address
    @device = I2C.create('/dev/i2c-1')
    @debug = debug
	if @debug
		puts 'Reset'
	end
    @device.write(@address, PCA9685_MODE1, 0x00)
  end

  def setPWMFreq(freq)
    prescaleval = 25000000.0    # 25MHz
    prescaleval /= 4096.0       # 12-bit
    prescaleval /= Float(freq)
    prescaleval -= 1.0
    if @debug
      puts "PWM frequency setting to: #{freq} Hz"
      puts "prescale computed to: #{prescaleval}"
    end
    prescale = (prescaleval + 0.5).floor
    if @debug
      puts "prescale setting to: #{prescale}"
    end

    oldmode = @device.read(@address, 8, PCA9685_MODE1).unpack('C').first
    newmode = (oldmode & 0x7F) | 0x10
    @device.write(@address, PCA9685_MODE1, newmode)
    @device.write(@address, PCA9685_PRESCALE, prescale)
    @device.write(@address, PCA9685_MODE1, oldmode)
    sleep(0.01)
    @device.write(@address, PCA9685_MODE1, oldmode | 0x80)
  end

  def setPWM(channel, on, off)
    @device.write(@address, PCA9685_LED0_ON_L+4*channel, on & 0xFF)
    @device.write(@address, PCA9685_LED0_ON_H+4*channel, on >> 8)
    @device.write(@address, PCA9685_LED0_OFF_L+4*channel, off & 0xFF)
    @device.write(@address, PCA9685_LED0_OFF_H+4*channel, off >> 8)
  end
end
