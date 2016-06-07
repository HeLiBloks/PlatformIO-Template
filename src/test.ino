/*- modeline  {{{
vim:set et sw=4 ts=4 ft=cpp syntax=arduino foldmarker={{{,}}} foldlevel=0 foldmethod=marker spell:
     }}} modeline -*/

#include <Wire.h>
#include <DallasTemperature.h>
#include <LiquidCrystal.h>
#include <math.h>

// Arduino ports
#define ONE_WIRE_BUS 3
OneWire oneWire(ONE_WIRE_BUS);

// pass one wire reference Dallas Temperature.
DallasTemperature sensors(&oneWire);
LiquidCrystal lcd(8, 9, 4, 5, 6, 7);

// define some values used by the panel and buttons
int lcd_key     = 0;
int adc_key_in  = 0;
#define btnRIGHT  0
#define btnUP     1
#define btnDOWN   2
#define btnLEFT   3
#define btnSELECT 4
#define btnNONE   5
// read the buttons
int read_LCD_buttons()
{
 adc_key_in = analogRead(0);      // read the value from the sensor
 // my buttons when read are centered at these valies: 0, 144, 329, 504, 741
 // we add approx 50 to those values and check to see if we are close
 if (adc_key_in > 1000) return btnNONE; // We make this the 1st option for speed reasons since it will be the most likely result
 // For V1.1 us this threshold
 if (adc_key_in < 50)   return btnRIGHT;
 if (adc_key_in < 250)  return btnUP;
 if (adc_key_in < 450)  return btnDOWN;
 if (adc_key_in < 650)  return btnLEFT;
 if (adc_key_in < 850)  return btnSELECT;

 // For V1.0 comment the other threshold and use the one below:
/*
 if (adc_key_in < 50)   return btnRIGHT;
 if (adc_key_in < 195)  return btnUP;
 if (adc_key_in < 380)  return btnDOWN;
 if (adc_key_in < 555)  return btnLEFT;
 if (adc_key_in < 790)  return btnSELECT;
*/
return btnNONE;  // when all others fail, return this...
}

int AnalogSensor(int pin){
    if (isDigit(pin)) {
        return analogRead(pin);
    }
};

/*int dht(int h){
  int chk = DHT11.read(DHT11PIN);
   switch (chk)
  {
    case 0: Serial.println("OK"); break;
    case -1: Serial.print("Checksum error"); break;
    case -2: Serial.print("Time out error"); break;
    default: Serial.print("Unknown error"); break;
  }
  h = DHT11.humidity;
    return h;
  }

int dhtt(int t){

  int chk = DHT11.read(DHT11PIN);
   switch (chk)
  {
    case 0: Serial.println("OK"); break;
    case -1: Serial.print("Checksum error"); break;
    case -2: Serial.print("Time out error"); break;
    default: Serial.print("Unknown error"); break;
  }
  t = DHT11.temperature;
    return t;
  }*/

int Mq3(int q){
  int gas;
 gas = q;

  // 300- 10 000 ppm sensitivity
 return gas;
};


int vib(int v){
  int vi;
 vi = v;
 return vi;
};

double Thermister(int RawADC) {

  double Temp;
  // See http://en.wikipedia.org/wiki/Thermistor for explanation of formula
  Temp = log(10000.0*((1024.0/RawADC-1)));
  //Temp = log(10000.0*((4092.0/RawADC-1)));
  Temp = 1 / (0.001129148 + (0.000234125 * Temp) + (0.0000000876741 * Temp * Temp * Temp));
  Temp = Temp - 273.15;           // Convert Kelvin to Celcius*/
  Temp = RawADC;
  return Temp;
}

void setup(void)
{
  // Start up the library
  sensors.begin();

  lcd.begin(16, 2);
}

void loop(void)
{
  double fTemp;

int i;
i = i++;
if (i%10 == 0){
  lcd.clear();
  lcd.print("clearing");
  delay(1000);
  lcd.clear();
}

  sensors.requestTemperatures(); // Read dallas
  //lcd.clear();
  lcd.setCursor(0, 0); // bottom left
  //lcd.print("Hu ");
  //lcd.print(DHT11.read(DHT11PIN));
  lcd.print("Ti ");
  lcd.print(sensors.getTempCByIndex(0));
  lcd.print(" C Tu");

  lcd.setCursor(0, 1); // bottom left
  //lcd.print("L ");
  //lcd.print (Thermister(analogRead(2)));
  //lcd.print (" C ");
  lcd.print(Mq3(analogRead(3)));
  lcd.print(" ppm ");
  lcd.print(AnalogSensor(1));
  lcd.print(" Lx");

}

