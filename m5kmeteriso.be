#Tasmota driver for M5Stack KMeterISO sensor
# Vendor docs: https://docs.m5stack.com/en/unit/KMeterISO%20Unit
# Based on original implementation: https://github.com/m5stack/M5Unit-KMeterISO/blob/main/src/M5UnitKmeterISO.cpp
# and https://tasmota.github.io/docs/Berry-Cookbook/#full-example
# Exposes single metric - Temperature in Celsius. No configuration needed.

import string

class M5KmeterISO
  var wire          #- if wire == nil then the module is not initialized -#
  var tC_i          # Temperature in Celsius, integer*100 (so need to divide by 100 to get actual temperature)
  var buf           # buffer to read data
  var msg           # message to post to Tasmota

#######################################################
# I2C addresses as documented in https://github.com/m5stack/M5Unit-KMeterISO/blob/main/src/M5UnitKmeterISO.cpp
#define KMETER_DEFAULT_ADDR                        0x66
#define KMETER_TEMP_VAL_REG                        0x00
#define KMETER_INTERNAL_TEMP_VAL_REG               0x10
#define KMETER_KMETER_ERROR_STATUS_REG             0x20
#define KMETER_TEMP_CELSIUS_STRING_REG             0x30
#define KMETER_TEMP_FAHRENHEIT_STRING_REG          0x40
#define KMETER_INTERNAL_TEMP_CELSIUS_STRING_REG    0x50
#define KMETER_INTERNAL_TEMP_FAHRENHEIT_STRING_REG 0x60
#define KMETER_FIRMWARE_VERSION_REG                0xFE
#define KMETER_I2C_ADDRESS_REG                     0xFF
########################################################


  # read temperature in Celsius from the sensor
  def readTempC()
    if !self.wire return nil end  #- exit if not initialized -#
    self.buf = self.wire.read_bytes(0x66,0x00,4)
    self.tC_i=self.buf.get(0,4)
#    print("M5KmeterISO Read int: "+str(self.tC_i)+" Bytes: "+self.buf.tostring())
  end


  def init()
    self.tC_i=0
    self.wire = tasmota.wire_scan(0x66, 0)
    if self.wire
      print("I2C: M5 KmeterISO detected on bus "+str(self.wire.bus))
      self.readTempC()
    end
  end

#- trigger a read every second -#
  def every_second()
    if !self.wire return nil end  #- exit if not initialized -#
    self.readTempC()
  end

  #- display sensor value in the web UI -#
  def web_sensor()
    if !self.wire return nil end  #- exit if not initialized -#
    self.msg = string.format(
             "M5KmeterISO T (C): %d", self.tC_i/100)
    tasmota.web_send_decimal(self.msg)
  end

  #- add sensor value to teleperiod -#
  def json_append()
    if !self.wire return nil end  #- exit if not initialized -#
    self.msg = string.format(",\"M5KmeterISO\":{\"Temperature\":%d}", self.tC_i/100 )
    tasmota.response_append(self.msg)
  end

end

m5kmeteriso = M5KmeterISO()
tasmota.add_driver(m5kmeteriso)