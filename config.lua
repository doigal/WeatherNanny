--------------------------------------------------------------------
--                        CONSTANTS & CONFIG
--------------------------------------------------------------------
-- Remember to blank out the details before uploading!

--ThingSpeak API Key
TS_API="" 

--Wifi Login Details
WIFI_SSID=""
WIFI_PASS=""

--Logs to thingspeak every x seconds:
LoopTime = 60

--Sensor Setup
SDA_PIN = 3 		-- sda pin, GPIO2
SCL_PIN = 4 		-- scl pin, GPIO0
BME280_ADDR = 0x76	-- BME280 i2c address
--BMP180_ADDR = 0x77	-- BMP180 i2c address (currently defined in the driver file)
BMP180_OSS = 1      -- oversampling setting (0-3)