#include <Arduino.h>
#include "geeWhiz.h"
#include <FspTimer.h>   // UNO R4 timer helper

#define HIGH_REF 0.7
#define LOW_REF -0.7

// ================== Global Variables ======
volatile int angle_counts = 0;       // gear angle
volatile float ServoAng   = 0.0;     // gear angle in rad
volatile int   pos_counts = 0;       // ball position
volatile float BallPos    = 0.0;     // ball position in m
volatile int          Tms = 100;     // 100 ms interrupt interval
float voltage = 0.0;
const float m = -0.0213;  // slope for radian conversion
const float offset = 120.24;  // offset for radian conversion
const float P = -5;  // Gain
int32_t T = 5000;   // Period for step function
float RefServoAng = 0.0; // target radian from input of step function

// ================== Pins ==================
int MOT_PIN = A0;   // motor angle sensor
int BAL_PIN = A1;   // ball position sensor

// ================== Setup ==================
void setup() {

  analogReadResolution(14);

  pinMode(A5, OUTPUT);   // A5 can be used to measure cycle time of ISR using an oscilloscope by connecting the scope to the Arduino Box Motor Leads
  Serial.begin(9600);
  delay(5000);

  geeWhizBegin(); 

  setMotorVoltage(0.0f);
  Serial.println("   ");
  Serial.println("   geeWhiz Started   -   10 second delay to allow setting up of CoolTerm ");
  Serial.flush();
  delay(10000);   // 10 sec delay to set up screen and CoolTerm data capture aso ...

  set_control_interval_ms(Tms); // Tms contains interrupt interval in ms  
}

// ================== Loop ==================
void loop() {
  RefServoAng = HIGH_REF;
  delay(2000);
  RefServoAng = LOW_REF;
  delay(2000);
}

// ================== Control ISR ==================
void interval_control_code(void) {
  // ---- Read sensors ----
  int motor = analogRead(MOT_PIN);
  angle_counts = motor;

  int ball  = analogRead(BAL_PIN);
  pos_counts = ball;

  ServoAng = (m * angle_counts + offset) * 3.14159/180; // rad
  float error = RefServoAng - ServoAng;

  voltage = P*error;
  setMotorVoltage(voltage);

  digitalWrite(A5,HIGH);   // A5 can be used to measure cycle time of ISR using an oscilloscope by connecting the scope to the Arduino Box Motor Leads
  Serial.print(pos_counts);
  Serial.print(",");
  Serial.println(ServoAng);
  digitalWrite(A5,LOW);    // A5 can be used to measure cycle time of ISR using an oscilloscope by connecting the scope to the Arduino Box Motor Leads
 
}