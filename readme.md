## Glowstone Cube ##

### Description ###
A 16cm x 16cm Cube with some Minecraft Textures. The Cube is able to "glow" in RGB colors.
Therefore the Cube contains an Raspberry Pi and an PCA9685 Board.


### Instructions ###

#### 1. Setup the Raspberry Pi's I2C interface ####

``$ sudo modprobe i2c_dev``

``$ sudo vi /etc/modules``

```
# Make sure it contains the lines:

snd-bcm2835
i2c-bcm2708
i2c-dev
```

``$ sudo vi /etc/modprobe.d/raspi-blacklist.conf ``

```
# Comment out following lines:

blacklist spi-bcm2708
blacklist i2c-bcm2708
```

``$ sudo apt-get install i2c-tools``

``$ sudo usermod -a -G i2c USERNAME``

#### 2. Install Your Ruby Environment ####

# Install Ruby on your Raspberry Pi
``$ sudo apt-get install ruby ruby-dev``

# Install the required Gems
`gem install i2c`
`gem install sinatra`
`gem install haml`pca

#### 3. Run it! ####

On Rev A Raspberry Pi: 
`sudo i2cdetect -y 0`
On Rev B Raspberry Pi:
`sudo i2cdetect -y 1`

Your PCA9685 should show up. If not check your Cables.


Run it via:
`ruby sinatra.rb`

### Relevant Links: ###

PCA9685 Datasheet:
http://www.nxp.com/documents/data_sheet/PCA9685.pdf

Original Adafruit Python Adafruit_PWM_Servo_Driver Library:
https://github.com/adafruit/Adafruit-Raspberry-Pi-Python-Code

Adafruit Learning System Info for PCA9685 as used in Lady Adas board:
http://learn.adafruit.com/adafruit-16-channel-servo-driver-with-raspberry-pi