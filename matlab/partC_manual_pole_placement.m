% Plant
Ts = 0.01;
np = -0.2588;
Np = [0 0 np];
Dp = [1 0 0];
P = tf(Np, Dp);
n = length(Dp)-1;
Pd = c2d(P, Ts);

%% Requirements
os_max = 0.45;  % max overshoot
t_settle_max = 7;  % max settling time

%% Choose params
zeta = 1;  % overshoot reduction
sigma = 0.3;  % speed of decay

%%
omega_n = sigma/zeta;
omega_d = sqrt(omega_n^2 - sigma^2);

% Dominant poles
s1 = -sigma - omega_d*1j;
s2 = -sigma + omega_d*1j;

% Non-dominant poles
s3 = -4;
s4 = -4.2;
s5 = -4.4;

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
Cd = c2d(C,Ts);

% Test
G_y = feedback(Cd*Pd, 1); % unity feedback system
[y, t] = step(0.03 * G_y);   % response to a 0.03 step
info = stepinfo(y, t, 0.03);
y = y + 0.15;                % add the initial value

fprintf('Settling time: %.3f s\n', info.SettlingTime);
fprintf('Overshoot: %.3f %\n', info.Overshoot);

% Control effort response
G_u = feedback(Cd, Pd);
[u, t_u] = step(0.03 * G_u);   % response to a 0.03 step
max_u = abs(min(u));
fprintf('Max control effort: %.3f %\n', max_u);

%% Discretize

% Discrete Closed loop stability
Gcl_d = feedback(Cd*Pd, 1);
pole(Gcl_d)
isstable(Gcl_d)