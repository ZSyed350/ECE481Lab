max_t_settle = 7;
max_overshoot = 45;
control_effort_sat = 0.7;

Ts = 0.01;
t_sim = (0:Ts:20)';

% Plant
np = -0.2588;
Np = [0 0 np];
Dp = [1 0 0];
P = tf(Np, Dp);
Pd = c2d(P, Ts);

results = zeros(5000,8);
for zeta = 0.2:0.1:1.0
    for sigma = 0.2:0.1:1.0
        fprintf('zeta: %.2f, sigma: %.2f\n', zeta, sigma);

        omega_n = sigma/zeta;
        omega_d = sqrt(omega_n^2 - sigma^2);
        
        % Dominant poles
        s1 = -sigma - omega_d*1j;
        s2 = -sigma + omega_d*1j;

        for s3 = -3:-0.2:-8
            for s4 = s3:-0.2:-8
                for s5 = s4:-0.2:-8
                    
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
                    Cd = c2d(C,Ts);

                    % Control effort response
                    G_u = feedback(Cd, Pd);
                    [u, t_u] = step(0.03 * G_u, t_sim);   % response to a 0.03 step
                    max_control_effort = max(max(u), abs(min(u)));
                    if max_control_effort > control_effort_sat
                        continue
                    end
                    
                    % Closed loop step response
                    G_y = feedback(Cd*Pd, 1); % unity feedback system
                    if ~isstable(G_y)
                        continue
                    end
                    [y, t] = step(0.03 * G_y, t_sim);   % response to a 0.03 step
                    info = stepinfo(y, t, 0.03);
              
                    % Stats
                    t_settle = info.SettlingTime;
                    overshoot = info.Overshoot;

                    % Check
                    cond1 = t_settle < max_t_settle;
                    cond2 = overshoot < max_overshoot;
                    if cond1 && cond2
                        results(end+1,:) = [zeta, sigma, s3, s4, s5, t_settle, overshoot, max_control_effort];
                    end
                end
            end
        end
    end
end

results = array2table(results, 'VariableNames', {'zeta','sigma', 's3', 's4', 's5', 't_settle', 'overshoot', 'max_control_effort'});
writetable(results, 'controller_results_3rd_order.xlsx');