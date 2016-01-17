--------------------------------------------------------------------
--                            FUNCTIONS
--------------------------------------------------------------------
-- Reading from BMP180 sensor
function ReadBMP180()
   bmp180 = require("bmp180")
   bmp180.init(SDA_PIN, SCL_PIN)
   bmp180.read(BMP180_OSS)
   BMP180_t = bmp180.getTemperature()
   BMP180_p = bmp180.getPressure()
   
   -- release module
   bmp180 = nil
   package.loaded["bmp180"]=nil
end

-- Reading from BME280 sensor
function ReadBME280()
   bme280 = require("bme280")
   node.heap()
   bme280_t, bme280_p, bme280_h = bme280.read()

   bme280 = nil
   package.loaded["bme280"]=nil
    
   --Debuging:
   --print("T: "..(bme280_t/1000).."."..(bme280_t%1000).." degC")
   --print("P: "..(bme280_p/100).."."..(bme280_p%100).." hPa")
   --print("H: "..(bme280_h/1000).."."..(bme280_h%1000).." %rH")
end
     
-- send to https://api.thingspeak.com
function sendTS(F1,F2,F3)
   conn = nil
   conn = net.createConnection(net.TCP, 0)
   conn:on("receive", function(conn, payload)success = true print(payload)end)
   conn:on("connection",
      function(conn, payload)
      print("Connected, sending T="..F1.."degC & P="..F2.."hPa & "..F3.."%rH to thingspeak")
      conn:send('GET /update?key='..TS_API..'&field1='..F1..'&field2='..F2..'&field3='..F3..'HTTP/1.1\r\n\
      Host: api.thingspeak.com\r\nAccept: */*\r\nUser-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n\r\n')end)
   conn:on("disconnection", function(conn, payload) end)
   conn:connect(80,'184.106.153.149') -- api.thingspeak.com 184.106.153.149
end   

function ReadSend()
  --BMP180 Version:
  --ReadBMP180()
  --sendTS((BMP180_t/10).."."..(BMP180_t%10),(BMP180_p/100).."."..(BMP180_p%100))

  --BME280 Version:
  ReadBME280()
  sendTS((bme280_t/1000).."."..(bme280_t%1000),(bme280_p/100).."."..(bme280_p%100),(bme280_h/1000).."."..(bme280_h%1000))

end   

-- Function to get the wifi initialised and start logging.
function ConnWifi()
   print("Begin Wifi Connection and confirm IP")
   wifi.sta.disconnect()
   wifi.setmode(wifi.STATION)
   wifi.sta.config(WIFI_SSID,WIFI_PASS)
   tmr.delay(5000000)

   -- Loop to wait for wifi connection
   tmr.alarm(1, 2500, 1, 
   function()
      ip = wifi.sta.getip()
      wifistatus = wifi.sta.status()
      print("Wifi Status Code: "..wifistatus)
      if wifi.sta.status() == 5 then
	      tmr.stop(1)
          print("Wifi is Connected!")
		  LogLoop()                      -- Go and run the main program
      else
	      print("Trying longer for wifi connection")
      end
   end
   )
end

-- Function to read the sensor and send to thingspeak.
function LogLoop()  
   print("IP: "..ip) 
   print("Take Initial Reading & sending to thingspeak")
   ReadSend()       
   print("Initial Reading:")
   
   --BMP180 Version:
   --print("Temperature: "..(BMP180_t/10).."."..(BMP180_t%10).." deg C")
   --print("Pressure: "..(BMP180_p / 100).."."..(BMP180_p % 100).." hPa")
   
   --BME280 Version:
   print("Temperature: "..(bme280_t/1000).."."..(bme280_t%1000).." degC")
   print("Pressure: "..(bme280_p/100).."."..(bme280_p%100).." hPa")
   print("Humidity: "..(bme280_h/1000).."."..(bme280_h%1000).." %rH")
   
   print("Logging mode. Sending data every "..LoopTime.."s to thingspeak")

   tmr.alarm(0, (LoopTime*1000), 1, function() ReadSend() end )
end


ConnWifi()