class OuterLoopController {
  float k = -7;
  float a_0 = 2.0035;
  float a_1 = -1.9965;
  float b_0 = 2.025;
  float b_1 = -1.975;

  float prev_ctrl_val = 0.0;
  float prev_e = 0.0;

  public:
    float control(float cur_e);
};