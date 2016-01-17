# WeatherNanny
ESP8266/NodeMCU based weather station, Designed to collect weather data from connected sensors and log to 'the cloud' (In this case thingspeak)

##INTENDED USAGE
The main idea of this is to have cheap (under £5 per station) IoT sensors that can report on various happenings around. For me that is simply seeing how hot/cold a few rooms are in the house, and comparing that to the outside temperature to measure heat loss. 

##HARDWARE:
#####ESP8266/NodeMCU module.  
I used a NodeMCU module as although they cost a litle more, they come with USB power. Simply put, USB plug packs are plenty, 3v3 are not. In theory this should work on any of the other ESP8266 modules out there, but its not been tested.

#####BME280 Temperature/Pressure/Humidity Sensor.  
Takes care of all the sensing needs.

##USAGE:  
This uses the NodeMCU integer firmware, available from:  
     https://github.com/nodemcu/nodemcu-firmware  
Connect the required sensors to the i2c bus.  
Setup the wifi details, pin config, i2d address, thingspeak details, etc in the config.lua file  
Enable the relevant sensors in the code  
Upload the required files using LuaLoader or your serial program of choice  
It strongly recommended that you check the setup before letting it run on boot.  

##CREDITS:
BMP180 Sensor libary from:  
https://github.com/javieryanez/nodemcu-modules/blob/master/bmp180/bmp180.lua
   
BME280 Sensor libary adapted from:  
https://github.com/wogum/esp12/blob/master/bme280.lua
   
Avoiding init.lua issues on startup:  
http://davidjohntaylor.co.uk/index.php/2015/07/30/avoid-init-lua-hell/

##FUTURE WORK:
- [ ] Compile modules to save space
- [ ] Auto reconnect on loss of wifi connection.
- [ ] Need to introduce the deep sleep function in between reads to save power.
- [ ] Make possible to power from solar so that it can be left outside (along with battery monitoring)
- [ ] Introduce more sensors, specifically:
  - [ ] AM2321   Temp/Humid sensor
  - [ ] TSL2561  Lux Sensor
  - [ ] MAX17043 Lipo charge sensor
