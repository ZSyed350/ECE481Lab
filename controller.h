class Controller {
  float a_0 = 2.34483;
  float a_1 = 1.65517;
  float b_0 = 2.34;
  float b_1 = 1.66;

  float prev_ctrl_val = 0.0;
  float prev_e = 0.0;

  public:
    float control(float cur_e);
};