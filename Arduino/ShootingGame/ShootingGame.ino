#include <Servo.h>;

//Servo digital pins (PWM)
Servo servo1;
int servoPin = 11;

Servo servo2;
int servoPin2 = 3;

Servo servo3;
int servoPin3 = 9;

//Analog pins (flex, slider, light sensors)
int flexSensor = 0; //Analog Input 0
int val_flex = 0;
boolean reloading = false;

//Previously had a touch sensor but it had problems, so we are using a button for the gun trigger now
int button = 5; //Digital pin 5
int buttonState = 0;
boolean shoot = false;

int sliderSensor = 2; //Analog Input 2
int val_slider = 0;

int lightSensor = 3; //Analog Input 3
int val_light = 0;
int val_lightDelay = 0;

int lightSensor2 = 4; //Analog Input 4
int val_light2 = 0;
int val_lightDelay2 = 0;

int lightSensor3 = 5; //Analog Input 5
int val_light3 = 0;
int val_lightDelay3 = 0;

//Piezo buzzer pin
int piezoBuzzerPin = 6;

//LED pins for the targets
int ledPinRed = 7;
boolean ledPinRedDetected = false;
int ledPinGreen = 4;
boolean ledPinGreenDetected = false;
int ledPinBlue = 12;
boolean ledPinBlueDetected = false;

//Laser pointer for the gun on digital pin 10
int laserPin = 10; //Digital Pin 10
boolean laserOn = true;

//Timers served for the servos for it to move in intervals (using millis())
long double timer = -2000;
long double timer2 = -2000;
long double timer3 = -2000;
long double servoTimer1 = 2000;
long double servoTimer2 = 2000;
long double servoTimer3 = 2000;
int servoInterval = 1000;

//Variables being sent through to Processing
//Ammo system
int ammo = 100;
int flex = 0;
int buttonValue = 0;
int light = 0;
int light2 = 0;
int light3 = 0;

//Color bullet buttons
int redButtonPin = 2;
int greenButtonPin = 8;
int blueButtonPin = 13;
boolean redPressed = false;
boolean greenPressed = false;
boolean bluePressed = false;
//Send this information to tell when the servo is down
int servoDown1 = 0;
int servoDown2 = 0;
int servoDown3 = 0;

//Game Timer
int gameTimer = 0;
int gameOver = 0;

void setup() {
  pinMode(laserPin, OUTPUT);
  pinMode(ledPinRed, OUTPUT);
  pinMode(ledPinGreen, OUTPUT);
  pinMode(ledPinBlue, OUTPUT);
  pinMode(piezoBuzzerPin, OUTPUT);
  pinMode(button, INPUT);
  servo1.attach(servoPin);
  servo2.attach(servoPin2);
  servo3.attach(servoPin3);
  pinMode(redButtonPin, INPUT);
  pinMode(greenButtonPin, INPUT);
  pinMode(blueButtonPin, INPUT);
  Serial.begin(9600);
}

void loop() {
  if (millis() - gameTimer >= 65000) { //if the game time has been over 60 seconds with 5 second intro screen
    gameOver = 1;
  }

  //Output values
  val_flex = analogRead(flexSensor)/4;
  val_slider = analogRead(sliderSensor)/4;
  buttonState = digitalRead(button);
  redPressed = digitalRead(redButtonPin);
  greenPressed = digitalRead(greenButtonPin);
  bluePressed = digitalRead(blueButtonPin);
  
  //val_touch = analogRead(touchSensor)/4;

  //String packets for processing
  Serial.println();
  Serial.print("!");
  Serial.print(flex);
  Serial.print("!");

  Serial.println();
  
  Serial.print("@");
  Serial.print(buttonValue);
  Serial.print("@");

  Serial.println();

  Serial.print("#");
  Serial.print(val_slider);
  Serial.print("#");

  Serial.println();

  Serial.print("$");
  Serial.print(light);
  Serial.print("$");

  Serial.println();

  Serial.print("%");
  Serial.print(light2);
  Serial.print("%");

  Serial.println();

  Serial.print("^");
  Serial.print(light3);
  Serial.print("^");

  Serial.println();

  Serial.print("&");
  Serial.print(ammo);
  Serial.print("&");

  Serial.println();

  Serial.print("a");
  Serial.print(servoDown1);
  Serial.print("a");

  Serial.println();

  Serial.print("b");
  Serial.print(servoDown2);
  Serial.print("b");

  Serial.println();

  Serial.print("c");
  Serial.print(servoDown3);
  Serial.print("c");

  Serial.println();

  Serial.print("g");
  Serial.print(gameOver);
  Serial.print("g");

  Serial.println();
  Serial.print("*"); //denotes end of readings from both sensors

  //Game logic
  if (gameOver == 0) { //Game is not over
    //Shooting and reloading logic
    if (val_flex >= 120) { //Reload
      reloading = true;
      flex = 1;
      ammo = 100;
    }
    else {
      reloading = false;
      flex = 0;
    }
    //Shoot bullets if trigger is on and has ammo
    if (buttonState == HIGH && ammo > 0) {
      laserOn = true;
      buttonValue = 1;
      ammo -= 4;
    }
    else {
      laserOn = false;
      buttonValue = 0;
    }
  
    //Turn on laser pointer (By button) - Cannot shoot while reloading
    if (laserOn && !reloading) {
      digitalWrite(laserPin, HIGH);
    }
    else digitalWrite(laserPin, LOW);
  
    //Light Sensor Readings
    val_light = analogRead(lightSensor)/4;
    val_light2 = analogRead(lightSensor2)/4;
    val_light3 = analogRead(lightSensor3)/4;
    delay(100);
    //delays are for the old method of light sensing, but it was changed
    val_lightDelay = analogRead(lightSensor)/4;
    val_lightDelay2 = analogRead(lightSensor2)/4;
    val_lightDelay3 = analogRead(lightSensor3)/4;
  //  if (millis() - lightDelayTimer >= 10) {
  //    lightDelayTimer = millis();
  //  }
    //Detect light sensor (Red)
    if (val_light > 240 && redPressed) { //For Light Sensor 1
      digitalWrite(ledPinRed, LOW);
      timer = millis();
      ledPinRedDetected = true;
      servoTimer1 = millis(); //Reset servoTimer
      light = 1;
      play('g', 2);
    }
    else {
      if (millis() - timer <= (val_slider + 1)*10 + 1000) { //If it has been hit within the pop-up time interval, stay down until the time interval is passed
        ledPinRedDetected = false;
        light = 0;
      }
      else {
      }
      
    }
    //Green
    if (val_light2 > 240 && greenPressed) { //For Light Sensor 1
      digitalWrite(ledPinGreen, LOW);
      timer2 = millis();
      ledPinGreenDetected = true;
      servoTimer2 = millis(); //Reset servoTimer
      light2 = 1;
      play('g', 2);
    }
    else {
      if (millis() - timer2 <= (val_slider + 1)*10 + 1000) { //If it is still less than 2 seconds, keep it low
        ledPinGreenDetected = false;
        light2 = 0;
      }
      else {
      }
    }
    //Blue
    if (val_light3 > 240 && bluePressed) { //For Light Sensor 1
      digitalWrite(ledPinBlue, LOW);
      timer3 = millis();
      ledPinBlueDetected = true;
      servoTimer3 = millis(); //Reset servoTimer
      light3 = 1;
      play('g', 2);
    }
    else {
      if (millis() - timer3 <= (val_slider + 1)*10 + 1000) { //If it is still less than 2 seconds, keep it low
        ledPinBlueDetected = false;
        light3 = 0;
      }
      else {
      }
    }
    
    
    //Servos (Controlled by light sensor detection or timing out
    if(ledPinRedDetected || millis() - servoTimer1 >= (val_slider + 1)*10 + 1000) { //Down after some interval decided by the slider sensor
      servo1.write(0);
      servoDown1 = 0;
      digitalWrite(ledPinRed, HIGH);
      if (ledPinRedDetected || millis() - servoTimer1 >= (val_slider + 1)*20 + 2000) {
        servoTimer1 = millis();
      }
    }
    else {
      servo1.write(90);
      servoDown1 = 1;
      digitalWrite(ledPinRed, LOW);
    }
    //Green
    if(ledPinGreenDetected || millis() - servoTimer2 >= (val_slider + 1)*10 + 1000) { //Down after some interval decided by the slider sensor
      servo2.write(0);
      servoDown2 = 0;
      digitalWrite(ledPinGreen, HIGH);
      if (ledPinGreenDetected || millis() - servoTimer2 >= (val_slider + 1)*20 + 2000) {
        servoTimer2 = millis();
      }
    }
    else {
      servo2.write(90);
      servoDown2 = 1;
      digitalWrite(ledPinGreen, LOW);
    }
    //Blue
    if(ledPinBlueDetected || millis() - servoTimer3 >= (val_slider + 1)*10 + 1000) { //Down after some interval decided by the slider sensor
      servo3.write(0);
      servoDown3 = 0;
      digitalWrite(ledPinBlue, HIGH);
      if (ledPinBlueDetected || millis() - servoTimer3 >= (val_slider + 1)*20 + 2000) {
        servoTimer3 = millis();
      }
    }
    else {
      servo3.write(90);
      servoDown3 = 1;
      digitalWrite(ledPinBlue, LOW);
    }
  }
}

//Imported from Arduino tinker kit (piezo buzzer code)
void play( char note, int beats)
{
  int numNotes = 14;  // number of notes in our note and frequency array (there are 15 values, but arrays start at 0)

  //Note: these notes are C major (there are no sharps or flats)

  //this array is used to look up the notes
  char notes[] = { 'c', 'd', 'e', 'f', 'g', 'a', 'b', 'C', 'D', 'E', 'F', 'G', 'A', 'B', ' '};
  //this array matches frequencies with each letter (e.g. the 4th note is 'f', the 4th frequency is 175)
  int frequencies[] = {131, 147, 165, 175, 196, 220, 247, 262, 294, 330, 349, 392, 440, 494, 0};

  int currentFrequency = 0;    //the frequency that we find when we look up a frequency in the arrays
  int beatLength = 150;   //the length of one beat (changing this will speed up or slow down the tempo of the song)

  //look up the frequency that corresponds to the note
  for (int i = 0; i < numNotes; i++)  // check each value in notes from 0 to 14
  {
    if (notes[i] == note)             // does the letter passed to the play function match the letter in the array?
    {
      currentFrequency = frequencies[i];   // Yes! Set the current frequency to match that note
    }
  }

  //play the frequency that matched our letter for the number of beats passed to the play function
  tone(piezoBuzzerPin, currentFrequency, beats * beatLength);
  delay(beats* beatLength);   //wait for the length of the tone so that it has time to play

  delay(50);                  //a little delay between the notes makes the song sound more natural

}
