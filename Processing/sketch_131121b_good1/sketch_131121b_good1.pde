import processing.serial.*;
import java.awt.datatransfer.*;
import java.awt.Toolkit;

Serial port;
int[] xs = new int[6];
int[] ys = new int[6];

void setup(){
 size(1200,400);
 port = new Serial(this, "COM7", 9600); //remember to replace COM7 with the appropriate serial port on your computer
 
 //initialize the position of all the boxes
 xs[0] = 0;
 xs[1] = 200;
 xs[2] = 400;
 xs[3] = 600;
 xs[4] = 800;
 xs[5] = 1000;
 ys[0] = 0;
 ys[1] = 0;
 ys[2] = 0;
 ys[3] = 0;
 ys[4] = 0;
 ys[5] = 0;
}
 
 
String buff = "";

//arrays to hold the color data from the sensors
int[] wRed = new int[6];
int[] wGreen = new int[6];
int[] wBlue = new int[6];
int[] wClear = new int[6];
String hexColor = "ffffff";



void draw(){

  //iterate through all the color sensors
 for(int i = 0; i < 6; i++)
 {
   //fill the rentangle with the sensor's color only when something is in range 
   if(wClear[i]>1600) {
     fill(wRed[i],wGreen[i],wBlue[i]);
   } else {
     fill(0,0,0);
   }
   
   rect(xs[i],ys[i],200,400);
   
   //draw a bar indicating the level of the clear value
   fill(204,255,255);
   rect(xs[i],400-map(wClear[i],0,2000,0,400),10,map(wClear[i],0,2000,0,400));
   
 }
 // check for serial, and process 
 
 while (port.available() > 0) {
   serialEvent(port.read());
 }
 
}
 
void serialEvent(int serial) {
 if(serial != '\n') {
   //add characters to the buffer if not at the end of the line
   buff += char(serial);
 } else {
   
   String[] val = buff.split(";");
   for(int i = 0; i<6; i++)
   {
     String[] colors = val[i].split(":");
     wClear[i] = Integer.parseInt(colors[0].trim());
     wRed[i] = Integer.parseInt(colors[1].trim());
     wGreen[i] = Integer.parseInt(colors[2].trim());
     wBlue[i] = Integer.parseInt(colors[3].trim());
     
     
     wRed[i] *= 255; wRed[i] /= wClear[i];
     wGreen[i] *= 255; wGreen[i] /= wClear[i]; 
     wBlue[i] *= 255; wBlue[i] /= wClear[i]; 
     
   }
   buff = ""; 
 }
}
