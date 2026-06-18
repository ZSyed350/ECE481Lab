#include <Arduino.h>
#include "geeWhiz.h"
#include <FspTimer.h>   // UNO R4 timer helper
#include "controller.h"

#define HIGH_REF 0.1
#define LOW_REF -0.1

// ================== Global Variables ======
volatile int angle_counts = 0;       // gear angle
volatile float ServoAng   = 0.0;     // gear angle in rad
volatile int   pos_counts = 0;       // ball position
volatile float BallPos    = 0.0;     // ball position in m
volatile int          Tms = 10;     // 100 ms interrupt interval
float voltage = 0.0;
const float m_motor = -0.0213;      // slope for radian conversion
const float offset_motor = 120.24;  // offset for radian conversion
const float m_ball = 0.0000245;       // slope for ball effective position in meters
const float offset_ball = -0.0161;  // offset for ball effective position in meters
const float P = -30;  // Gain
int32_t T = 5000;   // Period for step function
float RefServoAng = 0.0; // target radian from input of step function
int timeCounter = 0;
Controller ctrlr;

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
  // RefServoAng = HIGH_REF;
  delay(2000);
  // RefServoAng = LOW_REF;
  delay(2000);
}

// ================== Control ISR ==================
void interval_control_code(void) {
  // ---- Read sensors ----
  int motor = analogRead(MOT_PIN);
  angle_counts = motor;

  int ball  = analogRead(BAL_PIN);
  pos_counts = ball;

  // Saturator
  if (RefServoAng > 0.7)
    RefServoAng = 0.7;
  else if (RefServoAng < -0.7)
    RefServoAng = -0.7;

  // Control
  ServoAng = (m_motor * angle_counts + offset_motor) * 3.14159/180; // rad
  float error = RefServoAng - ServoAng;
  voltage = ctrlr.control(error);
  if (ServoAng > 0.8 || ServoAng < -0.8)
    voltage = 0.0;
  setMotorVoltage(voltage);

  digitalWrite(A5,HIGH);   // motor angle sensor - A5 can be used to measure cycle time of ISR using an oscilloscope by connecting the scope to the Arduino Box Motor Leads

  // Effective Ball Position (in meters)
  float effBallPos = m_ball * pos_counts + offset_ball;

  // Timer
  timeCounter += 10;

  // Printing
  Serial.print(timeCounter);
  Serial.print(",");
  Serial.print(RefServoAng);
  Serial.print(",");
  Serial.print(ServoAng);
  Serial.print(",");
  Serial.println(effBallPos);

  digitalWrite(A5,LOW);    // A5 can be used to measure cycle time of ISR using an oscilloscope by connecting the scope to the Arduino Box Motor Leads
}