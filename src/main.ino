/*- modeline  {{{
vim:set et sw=4 ts=4 ft=cpp syntax=arduino foldmarker={{{,}}} foldlevel=0 foldmethod=marker spell:
    }}} modeline -*/
#include <Arduino.h>
#include <Wire.h>
#include <DallasTemperature.h>
#include <LiquidCrystal.h>
#include <math.h>

// Arduino ports
#define PORT 3

void setup(void)
{
    Serial.println("set something upp");

};

int porticus = PORT + 1;
int AnalogSensor(int pin){
    if (isDigit(pin)) {
        return analogRead(pin);
    }
    return 0;
};

void loop(void)
{
    Serial.println(AnalogSensor(porticus));
};

