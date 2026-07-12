#include "gear_ang_controller.h"

float GearAngController::control(float cur_e) {
  float out = (k*(a_0*cur_e + a_1*prev_e) - b_1*prev_ctrl_val)/b_0;
  prev_e = cur_e;
  prev_ctrl_val = out;
  return out;
}