zeta = 0.498;  % overshoot reduction
sigma = 0.3;  % speed of decay

omega_n = sigma/zeta;
omega_d = sqrt(omega_n^2 - sigma^2);

% Dominant poles
s1 = -sigma - omega_d*1j;
s2 = -sigma + omega_d*1j;

% Non-dominant poles
s3 = -8*sigma;
s4 = -10*sigma;
s5 = -11*sigma;

% Controller
Nc = [-162.0139 -90.1688 -33.3170];
Dc = [1.0000 9.3000 30.6029 0];
C = tf(Nc, Dc);
Ts = 0.01;
Cd = c2d(C,Ts);
