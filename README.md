# Tasmota driver for M5Stack KMeterISO sensor

Vendor docs: https://docs.m5stack.com/en/unit/KMeterISO%20Unit

Based on original implementation: https://github.com/m5stack/M5Unit-KMeterISO/blob/main/src/M5UnitKmeterISO.cpp and https://tasmota.github.io/docs/Berry-Cookbook/#full-example .

Exposes single metric - Temperature in Celsius. No configuration needed.

The code can be loaded manually with copy/paste, or stored in flash and loaded at startup in `autoexec.be` as `load("m5kmeteriso.be")`. Alternatively it can be loaded with a Tasmota native command or rule:

```
Br load("m5kmeteriso.be")
```
