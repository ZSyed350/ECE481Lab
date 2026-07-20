class OuterLoopController {
  float k = -5;
  float a_0 = 89.102;
  float a_1 = -175.9956;
  float a_2 = 86.9022;
  float b_0 = 1;
  float b_1 = -1.6;
  float b_2 = 0.6;

  float u_k_1 = 0.0;
  float u_k_2 = 0.0;
  float e_k_1 = 0.0;
  float e_k_2 = 0.0;

  public:
    float control(float e_k);
};