#include "outer_loop_controller.h"

float OuterLoopController::control(float e_k) {
  float u_k = (a_0*e_k + a_1*e_k_1 + a_2*e_k_2 - b_1*u_k_1 - b_2*u_k_2 - b_3*u_k_3)/b_0;
  u_k_3 = u_k_2;
  u_k_2 = u_k_1;
  u_k_1 = u_k;
  e_k_2 = e_k_1;
  e_k_1 = e_k;
  return u_k;
}