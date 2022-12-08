import ddf.minim.*;

Minim minim;
AudioPlayer circusSong; //Taken from https://www.youtube.com/watch?v=zjedLeVGcfE&ab_channel=SuperJessTheMess


//images 
PImage background, scoreboard, enemy, enemyGreen, enemyBlue, easyMode,hardMode, normalMode;

boolean welcomePage = true;  // welcome page

//
import processing.serial.*;
int score = 0;
Serial port; // Create object from Serial class

//All the values taken from arduino
int valP_flex; // Data received from the serial port - variable to store the flex sensor reading
int valP_touch; // Data received from the serial port - variable to store the touch sensor reading
int valP_slider; // Data received from the serial port - variable to store the slider sensor reading
int valP_light; // Data received from the serial port - variable to store the light sensor reading
int valP_light2; // Data received from the serial port - variable to store the light sensor reading
int valP_light3; // Data received from the serial port - variable to store the light sensor reading
int valP_ammo;
int valP_servo1;
int valP_servo2;
int valP_servo3;
int valP_gameOver; //Tells if the game is over


byte[] inBuffer = new byte[200]; //size of the serial buffer to allow for end of data characters and all chars (see arduino code)

//booleans to detect if hit has been detected on the corresponding clown (to increment once per hit)
boolean hitDetected1 = false;
boolean hitDetected2 = false;
boolean hitDetected3 = false;
int hitTimer1 = 10;
int hitTimer2 = 10;
int hitTimer3 = 10;
//Game timer (65 seconds - 5 seconds for intro page, 60 seconds for the game - based on 10 fps)
int totalGameTime = 65*10;

public void settings() {
  size(1000, 700);
}
void setup(){
  loading();
  noStroke();
  frameRate(10); // Run 10 frames per second
  
  
  // Open the port that the board is connected to and use the same speed (9600 bps)
  port = new Serial(this, Serial.list()[0], 9600);
  
  minim= new Minim(this);
  
  circusSong=minim.loadFile("circus_theme_song.mp3");
  circusSong.play(0);
  
  
}
void loading() {
  //All these images are either drawn or modified from emojis by Xing Chen Cao 
   background =loadImage("background.png");
   scoreboard = loadImage("scoreboard.png");
   enemy = loadImage("enemy.png");
   enemyGreen = loadImage("enemy_green.png");
   enemyBlue = loadImage("enemy_blue.png");
   easyMode = loadImage("easy_mode.png");
   hardMode = loadImage("hard_mode.png");
   normalMode = loadImage("normal_mode.png");
   
}

void draw(){
  if (0 < port.available()) { // If data is available to read,
  
      port.readBytesUntil('*', inBuffer);  //read in all data until '&' is encountered
      
      if (inBuffer != null) {
        try { //ArrayIndexOutOfBoundsException occurs at the start as the inputs are buffering, throw these exceptions and wait for real inputs
          String myString = new String(inBuffer);
          //println(myString);  //for testing only
          
          String[] p = splitTokens(myString, "*");
          //println(p[0]);   //for testing only
          
          //for light senser      
          String[] flex_sensor = splitTokens(p[0], "!");  //get flex sensor reading 
          //println(flex_sensor[1]);
          valP_flex= int(flex_sensor[1]);
          
          print("flex sensor:");
          print(valP_flex);
          println(" ");  
          
          //for touch sensor  
          String[] touch_sensor=splitTokens(p[0], "@");  //get touch sensor reading
          //println(touch_sensor[1]);
          valP_touch = int(touch_sensor[1]);
          
          print("touch sensor:");
          print(valP_touch);
          println(" "); 
          
          //for slider sensor
          String[] slider_sensor= splitTokens(p[0], "#");  //get slider sensor reading
          //println(slider_sensor[1]);
          valP_slider =int (slider_sensor[1]);
          
          print("slider sensor:");
          print(valP_slider);
          println(" "); 
          
          //for light sensor 1
          String[] light_sensor= splitTokens(p[0], "$");  //get light sensor reading
          //println(light_sensor[1]);
          valP_light = int (light_sensor[1]);
          
          print("light sensor:");
          print(valP_light);
          println(" "); 
          
                  //for light sensor 2
          String[] light_sensor2= splitTokens(p[0], "%");  //get light sensor2 reading
          //println(light_sensor2[1]);
          valP_light2 = int (light_sensor2[1]);
          
          print("light sensor2:");
          print(valP_light2);
          println(" "); 
          
                  //for light sensor 3
          String[] light_sensor3= splitTokens(p[0], "^");  //get light sensor3 reading
          //println(light_sensor3[1]);
          valP_light3 = int (light_sensor3[1]);
          
          print("light sensor3:");
          print(valP_light3);
          println(" "); 
          
                  //for light sensor
          String[] ammo= splitTokens(p[0], "&");  //get ammo reading
          //println(ammo[1]);
          valP_ammo = int (ammo[1]);
          
          print("ammo:");
          print(valP_ammo);
          println(" "); 
          
          String[] servo1= splitTokens(p[0], "a");  //get servo1 reading
          //println(servo1[1]);
          valP_servo1 = int (servo1[1]);
          
          print("servo1:");
          print(valP_servo1);
          println(" "); 
          
          String[] servo2= splitTokens(p[0], "b");  //get servo2 reading
          //println(servo2[1]);
          valP_servo2 = int (servo2[1]);
          
          print("servo2:");
          print(valP_servo2);
          println(" "); 
          
          String[] servo3 = splitTokens(p[0], "c");  //get servo3 reading
          //println(servo1[1]);
          valP_servo3 = int (servo3[1]);
          
          print("servo3:");
          print(valP_servo3);
          println(" "); 
          
          String[] gameOver = splitTokens(p[0], "g");  //check if game is over
          //println(gameOver[1]);
          valP_gameOver = int (gameOver[1]);
          
          print("gameOver:");
          print(valP_gameOver);
          println(" "); 
        }
        catch (ArrayIndexOutOfBoundsException e) { //Catch Array exceptions (always happens at the start of the program)
          println("exception");
        }
        
        
        //display square and circle with text above, to illustrate functionality of code
        //PFont font;
        background(245); // Clear background
        //font = loadFont("ArialMT-24.vlw"); //font file has to be in the same folder as sketch (go Tools/ CreateFont/etc...)
        //textFont(font); 
        
        
        ////if light sensor has been hit
        //if(valP_light == 1){
        //  //hit 
        //  fill(0);
        //  score +=1;
          
        //}
        ////if light sensor has not been hit
        //else{
        //  //target appears 
        //  fill(252, 3, 3); 
        //  ellipse(290, 290, 200,200);
        //}
        ////done
     }
  }
  
  /////Game display
  drawBackground();
  if(totalGameTime >= 60*10){ //Intro screen
    
    drawStart();
    PFont Bauhaus = loadFont("Bauhaus93-48.vlw");  
    textFont(Bauhaus, 48);
    textAlign(CENTER);
    fill(130, 5, 7);
    text("CLOWN SHOOTER!", width / 2, height / 3);
    PFont Arial = loadFont("Arial-BoldMT-48.vlw");
    textFont(Arial, 24);
    fill(11, 75, 179);
    text("Help us shoot the scary clowns", width / 2, height / 3+60);
    PFont Nanum = loadFont("NanumPen-48.vlw");
    fill(0);
    textFont(Nanum, 36);
    
  }
  else {
    if(totalGameTime >= 0){
      /*
       * enemy controls
       */ 
       
       pushMatrix();
       scale(0.4);
       
       //Clown display logic 
       //valP_servo# -> servo is up, value == 0; servo is down, value == 1;
       
       //Drawing logic (draw when clown is up)
       if (valP_servo1 == 0) {
         image(enemy,200,600); //Left clown (Red LED)
       }
       if (valP_servo2 == 0) {
         image(enemyGreen,910,600); //Middle clown (Green LED)
       }
       if (valP_servo3 == 0) {
         image(enemyBlue,1630,600); //Right clown (Blue LED)
       }
       
       //Score counting logic
       if (valP_light == 1 && hitDetected1 == false) {
         score++;
         hitDetected1 = true;
       }
       if (hitDetected1 && hitTimer1 != -1) {
         hitTimer1--;
         if (hitTimer1 == -1) { //reset back to normal (can be hit again)
           hitTimer1 = 10;
           hitDetected1 = false;
         }
       }
       
       if (valP_light2 == 1 && hitDetected2 == false) {
         score++;
         hitDetected2 = true;
       }
       if (hitDetected2 && hitTimer2 != -1) {
         hitTimer2--;
         if (hitTimer2 == -1) { //reset back to normal (can be hit again)
           hitTimer2 = 10;
           hitDetected2 = false;
         }
       }
       
       if (valP_light3 == 1 && hitDetected3 == false) {
         score++;
         hitDetected3 = true;
       }
       if (hitDetected3 && hitTimer3 != -1) {
         hitTimer3--;
         if (hitTimer3 == -1) { //reset back to normal (can be hit again)
           hitTimer3 = 10;
           hitDetected3 = false;
         }
       }
       popMatrix();
       
       //Draw timer, ammo count, etc.
       drawAmmo();
      
    }
    else{  // Game is over
      drawBackground();//background for welcome
      drawStart();
      
      PFont Bauhaus = loadFont("Bauhaus93-48.vlw");  // the font is stored in the "data" file
      textFont(Bauhaus, 48);
      textAlign(CENTER);
      fill(235, 199, 56);
      text("GAME OVER", width / 2, height / 3);
      fill(0);
      PFont arial = loadFont("Arial-BoldMT-48.vlw");  // the font is stored in the "data" file
      textFont(arial, 48);
      text("YOUR SCORE: " + score, width / 2, height / 2-50);
      //PFont Nanum = loadFont("NanumPen-48.vlw");
      //textFont(Nanum, 36);

    }
  }
  
  totalGameTime--;
}

void drawBackground(){
  background(background);
  fill(255);
  noStroke();

}

void drawAmmo(){
  
  // display the score, health at right top corner at size 44
  pushMatrix();
  scale(0.3);
  image(scoreboard, 950, 0);
  popMatrix();
  
  PFont arial = loadFont("Arial-BoldMT-48.vlw");  // the font is stored in the "data" file
  fill(255);
  textFont(arial, 40);
  text("TIMER: " + int(totalGameTime/10), 0.05*width - 40,  0.05*height + 80);
  textFont(arial, 60);
  textAlign(LEFT);
  fill(153, 14, 14);
 
  text(score, 0.05*width + 480, 0.13*height + 10);
  
  //Slider sensor display logic
   //if the slider sensor value is small
  if (valP_slider < 3) {
    pushMatrix();
    scale(0.15);
    image(easyMode, 5500, 100);
    popMatrix();
  }
  //if the slider sensor value is in the middle
  else if (valP_slider < 6){
    pushMatrix();
    scale(0.15);
    image(normalMode, 5500, 90);
    popMatrix();
  }
//if the slider sensor value is large
  else {
    pushMatrix();
    scale(0.15);
    image(hardMode, 5480, 100);
    popMatrix();
  }
  
  //Ammo display logic
  if (valP_ammo < 30)
  {
    fill(255, 0, 0);
  }  
  else if (valP_ammo < 60)
  {
    fill(255, 200, 0);
  }
  else
  {
    fill(0, 255, 0);
  }
  
  noStroke();
  
  float drawWidth = 150 * 0.1 * valP_ammo/10;
  rect(30, 50, drawWidth, 20);
  
  textFont(arial, 20);
  fill(255);
  text("AMMO: " + valP_ammo, 0.05*width, 0.05*height);

  // Outline
  stroke(255);
  noFill();
  rect(30, 50, 150, 20);
       
}

void drawStart(){
    //bottom clown
    pushMatrix();
    scale(0.5);
    rotate(6);
    image(enemy,800,1400);
    popMatrix();
    
    //top clown
    pushMatrix();
    scale(0.5);
    rotate(3);
    image(enemy,-500,-500);
    popMatrix();

  
}
