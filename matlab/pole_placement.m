% Choosing strictly-proper controller to prevent instantaneous spike in
% control value at reference discontinuities, such as steps.
% Choosing an integrator for 0 steady state error

% plant is second order, n = 2
% strictly-proper, choosing m = 2

% Plant
np = -0.2588;
Np = [0 0 np];
Dp = [1 0 0];
P = tf(Np, Dp);
n = length(Dp)-1;

%% Requirements
os_max = 0.45;  % max overshoot
t_settle_max = 7;  % max settling time

%% The following requirements are only for 2nd order systems
zeta_min = -log(os_max) / sqrt(pi^2 + log(os_max)^2);  % 0.24634
sigma_min = 4/t_settle_max;  % 0.5714

%% Choose params
zeta = 0.498;  % overshoot reduction
sigma = 0.3;  % speed of decay

%%
omega_n = sigma/zeta;
omega_d = sqrt(omega_n^2 - sigma^2);

% Dominant poles
s1 = -sigma - omega_d*1j;
s2 = -sigma + omega_d*1j;

% Non-dominant poles
s3 = -8*sigma;
s4 = -10*sigma;
s5 = -11*sigma;

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

% Test
G_y = feedback(C*P, 1); % unity feedback system
[y, t] = step(0.03 * G_y);   % response to a 0.03 step
y = y + 0.15;                % add the initial value
info = stepinfo(y, t, 0.18);

fprintf('Settling time: %.3f s\n', info.SettlingTime);
fprintf('Overshoot: %.3f %\n', info.Overshoot);

%% Control effort response
G_u = feedback(C, P);
step(0.03 * G_u);   % response to a 0.03 step

%% Discretize
Ts = 0.01;
Cd = c2d(C,Ts)

%%
% % Sylvester Matrix
% S_full = zeros(2*n); % Sylvester matrix to be constructed
% for i=1:n
%     S_full(i:i+n, i) = Dp';
%     S_full(i:i+n, i+n) = Np';
% end
% 
% % Remove column corresponding to f0
% % Original unknown order: [f1; f0; g1; g0]
% S = S_full(:, [1 3 4]);
% 
% if (length(Lambda) ~= 2*n)
%     disp('Incorrect number of desired pole locations selected');
%     C = [];
% else
%     pides = poly(Lambda); % desired ch.p.
% 
%     % compute controller gains
%     rhs = pides(2:end).' - [Dp(2:n+1).'; zeros(n,1)];
%     gains = S\rhs;
%     Dc = [1 gains(1) 0];
%     Nc = gains(2:3).';
%     C = tf(Nc, Dc); % controller
% end
