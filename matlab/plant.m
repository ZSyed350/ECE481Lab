Np = [0 0 -0.2588];
Dp = [1 0 0];
P = tf(Np, Dp);
Ts = 0.01;
Pd = c2d(P, Ts);