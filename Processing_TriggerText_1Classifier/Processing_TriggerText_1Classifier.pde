//This demo triggers a text display with each new message
// Works with 1 classifier output, any number of classes
//Listens on port 12000 for message /wek/outputs (defaults)

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
import processing.sound.*;
SoundFile file1;
SoundFile file2;
SoundFile file3;
OscP5 oscP5;
NetAddress dest;

PImage img1, img2, img3;


//No need to edit:
PFont myFont, myBigFont;
final int myHeight = 600;
final int myWidth = 600;
int frameNum = 0;
int currentHue = 100;
int currentTextHue = 255;
String currentMessage = "";
int ff = 0;

void setup() {
  //Initialize OSC communication
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  
  colorMode(HSB);
  size(600,600, P3D);
  smooth();
  background(255);
  
  
  img1 = loadImage("happy.PNG");
  img2 = loadImage("sad.PNG");
  img3 = loadImage("anger.PNG");
  
  String typeTag = "f";
  
  //myFont = loadFont("SansSerif-14.vlw");
  myFont = createFont("Arial", 14);
  myBigFont = createFont("Arial", 80);
}

void draw() {
  frameRate(30);
  background(currentHue, 255, 255);
  int i = ff;
  drawText();
  if (i==1){
      currentMessage = "Happy";
      drawImg(img1);
    }
    if (i==2){
      currentMessage = "Sad";
      drawImg(img2);
    }
    if (i==3){
      currentMessage = "Angry";
      drawImg(img3);
    }
        if (i==4){
      currentMessage = "yell";
    }
        if (i==5){
      currentMessage = "tired";
    }
  
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 println("received message");
    if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
      if(theOscMessage.checkTypetag("f")) {
      float f = theOscMessage.get(0).floatValue();
      println("received1");
      ff = (int)f;
       showMessage(ff);
      }
    }
 
}

void showMessage(int i) {
    currentHue = (int)generateColor(i);
    currentTextHue = (int)generateColor((i+1));
    if (i==1){
      currentMessage = "Happy";
    }
    if (i==2){
      currentMessage = "Sad";

    }
    if (i==3){
      currentMessage = "Angry";

    }
    
}

void drawImg(PImage imgg) {
    image(imgg, 0, 0, width, height);
}

//Write instructions to screen.
void drawText() {
    stroke(0);
    textFont(myFont);
    textAlign(LEFT, TOP); 
    fill(currentTextHue, 255, 255);

    text("Receives 1 classifier output message from wekinator", 10, 10);
    text("Listening for OSC message /wek/outputs, port 12000", 10, 30);
    
    textFont(myBigFont);
    text(currentMessage, 90, 180);
}


float generateColor(int which) {
  float f = 100; 
  int i = which;
  if (i <= 0) {
     return 100;
  } 
  else {
     return (generateColor(which-1) + 1.61*255) %255; 
  }
}