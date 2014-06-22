#include <Wire.h>
#include "Adafruit_TCS34725.h"

//initialize color sensors objects
Adafruit_TCS34725 tcs[6] = Adafruit_TCS34725(TCS34725_INTEGRATIONTIME_50MS, TCS34725_GAIN_4X);

void setup() {
  
  byte ok = 1;
  
  Serial.begin(9600);
  Wire.begin();
  delay(10);
  
  //initialize all the sensors
  for(int i = 0; i<6;i++)
  {
    //switch i2c multiplexor
    Wire.beginTransmission(0x70);
    Wire.write(1 << i);
    Wire.endTransmission();
    
    delay(100);
    
    //attempt to connect the sensor
    if (tcs[i].begin())
    {
       //Sensor is connected!
    } else {
      //something went wrong
      Serial.println("No TCS34725 found at " + (String)i + " ... check your connections");
      ok = 0;
    }    
  
  }
  
  if(!ok)
  { //sensor not connected, halt the program
    Serial.println("Halting!");
    while (1); // halt!
  }
}


void loop() {
  
  //loop through the color sensors
  for(int i = 0; i<6;i++)
  {
    //Set the i2c switch to the desired output
    Wire.beginTransmission(0x70);
    Wire.write(1 << i);
    Wire.endTransmission();
    
    //wait for the switch to switch
    delay(1);
    
    uint16_t clear, red, green, blue;
  
    tcs[i].setInterrupt(false);      // turn on LED
  
    delay(50);  // takes 50ms to read 
    
    tcs[i].getRawData(&red, &green, &blue, &clear);
  
    tcs[i].setInterrupt(true);  // turn off LED
    
    //Print the data out over serial
                       Serial.print(clear);
    Serial.print(":"); Serial.print(red);
    Serial.print(":"); Serial.print(green);
    Serial.print(":"); Serial.print(blue);
    
    if(i != 5)
    {
      Serial.print(";");
    }
    else
    {
      Serial.print("\n");
    }
  }
}

