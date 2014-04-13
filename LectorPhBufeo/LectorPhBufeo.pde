/*
   Lector de señales PHMetro: Proyecto BUFEO
*/
#include <LiquidCrystal.h>

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

#include <SoftwareSerial.h>                                                    //add the soft serial libray
#define rxpin 0                                                               //set the RX pin to pin 2
#define txpin 1                                                               //set the TX pin to pin 3


SoftwareSerial myserial(rxpin, txpin);                                         //enable the soft serial port


String inputstring = "";                                                       //a string to hold incoming data from the PC
String sensorstring = "";                                                      //a string to hold the data from the Atlas Scientific product
boolean input_stringcomplete = false;                                          //have we received all the data from the PC
boolean sensor_stringcomplete = false;                                         //have we received all the data from the Atlas Scientific product


  void setup(){                                                                //set up the hardware
     Serial.begin(38400);                                                      //set baud rate for the hardware serial port to 38400
     myserial.begin(38400);                                                    //set baud rate for software serial port to 38400
     inputstring.reserve(5);                                                   //set aside some bytes for receiving data from the PC
     sensorstring.reserve(30);                                                 //set aside some bytes for receiving data from Atlas Scientific product
     }
 
 
 
   void serialEvent() {                                                         //if the hardware serial port receives a char
               char inchar = (char)Serial.read();                               //get the char we just received
               inputstring += inchar;                                           //add it to the inputString
               if(inchar == '\r') {input_stringcomplete = true;}                //if the incoming character is a <CR>, set the flag
              }  
 
 
 
 void loop(){                                                                   //here we go....
     
  if (input_stringcomplete){                                                   //if a string from the PC has been recived in its entierty 
      myserial.print(inputstring);                                             //send that string to the Atlas Scientific product
      lcd.print(inputstring);                                                  //
      inputstring = "";                                                        //clear the string:
      input_stringcomplete = false;                                            //reset the flage used to tell if we have recived a completed string from the PC
      }
 

  while (myserial.available()) {                                               //while a char is holding in the serial buffer
         char inchar = (char)myserial.read();                                  //get the new char
         sensorstring += inchar;                                               //add it to the sensorString
         if (inchar == '\r') {sensor_stringcomplete = true;}                   //if the incoming character is a <CR>, set the flag
         }


   if (sensor_stringcomplete){                                                 //if a string from the Atlas Scientific product has been received in its entirety
       Serial.print(sensorstring);                                             //use the hardware serial port to send that data to the PC sensorstring = "";
       lcd.print(sensorstring);                                                //print the current status of the pH into the LCD                                                             //clear the string:
       sensor_stringcomplete = false;                                          //reset the flag used to tell if we have received a completed string from the Atlas Scientific product
      }
}





