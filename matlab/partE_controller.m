max_t_settle = 8.5;
max_overshoot = 45;

Ts = 0.01;

% Plant
np = -0.2588;
Np = [0 0 np];
Dp = [1 0 0];
P = tf(Np, Dp);

zeta = 3;  % overshoot reduction
sigma = 2;  % speed of decay
s3 = -9;
s4 = -7;
s5 = -8;

omega_n = sigma/zeta;
omega_d = sqrt(omega_n^2 - sigma^2);

% Dominant poles
s1 = -sigma - omega_d*1j;
s2 = -sigma + omega_d*1j;
                    
% Solve controller
Lambda = [s1 s2 s3 s4 s5];
pides = poly(Lambda);
f2 = pides(2);
f1 = pides(3);
g2 = pides(4)/np;
g1 = pides(5)/np;
g0 = pides(6)/np;

Nc = [g2 g1 g0];
Dc = [1 f2 f1 0];
C = tf(Nc, Dc);