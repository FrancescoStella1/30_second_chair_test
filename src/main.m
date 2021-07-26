% $Author: Francesco Stella $

%% Data fusion and frame rotation

close all; clear all; clc;

Fs = 100;                                                                             % Sampling frequency fixed to 100 Hz
filename = 'subject2_14.mat';

[acceleration, orientation, angVel] = utils.load_data(filename);

% APPLY THE FUSION ALGORITHM
[est_orientation_quat, est_angVel] = utils.apply_fusion(acceleration, angVel);        % Get estimated orientation quaternion and angular velocity
eulerAngles = eulerd(est_orientation_quat, 'XYZ', 'frame');
figure();
plot(eulerAngles(:,1), 'green');
hold on;
plot(eulerAngles(:,2), 'blue');
legend('X-axis', 'Y-axis');
xlabel('time (10)^{-2} s');
ylabel('degrees');
title('Estimated Euler Angles for X and Y axes');

estimated_acceleration = rotateframe(est_orientation_quat, acceleration);             % Get estimated acceleration

orientation_reord = [orientation(:,2) orientation(:,3) orientation(:,1)];             % reorder in (Pitch, Roll, Azimuth) order
estimated_orientation = rotateframe(est_orientation_quat, orientation_reord);         % Get estimated orientation
x_orient = estimated_orientation(:,1);
x_orient = transpose(x_orient);

%% Computation and correction of relevant signals (vertical acceleration/velocity/position and x-axis orientation)

v_acc = estimated_acceleration(:,3) - 9.8;
v_acc = transpose(v_acc);

% Perform a lowpass filtering on the acceleration signal
Fc = utils.compute_Fc(v_acc, Fs);
v_acc = utils.lp_filter(v_acc, Fc, Fs);

% Compute vertical velocity and position
time = linspace(0, (length(v_acc))/100, length(v_acc));
v_vel = cumtrapz(time, v_acc);
v_pos = cumtrapz(time, v_vel);

% Z-axis acceleration
fig = figure();
figure(fig);
subplot(2,2,1);
plot(estimated_acceleration(:,3), 'blue');
hold on;
plot(acceleration(:,3), 'red');
plot(v_acc, 'green');

legend('IMUFilter', 'Sensor', 'w/out gravity');
xlabel('time (10^{-2} s)');
ylabel('Acceleration (m/s^2)');
title('Z-axis acceleration');

% Z-axis velocity correction
subplot(2,2,2);
[f_v_vel, df] = utils.poly_fit(v_vel, 4);
plot(v_vel, 'red');
hold on;
v_vel = v_vel - f_v_vel;
plot(v_vel, 'blue');

legend('with drift', 'w/out drift');
xlabel('time (10^{-2} s)');
ylabel('z-velocity (m/s)');
title('Z-axis velocity');

% Z-axis position
subplot(2,2,3);
plot(v_pos, 'red');
hold on;
v_pos = cumtrapz(time, v_vel);
plot(v_pos, 'blue');

legend('with drift', 'w/out drift');
xlabel('time (10^{-2} s)');
ylabel('z-position (m)');
title('Z-axis position');

% Baseline correction of Z-axis position
subplot(2,2,4);
plot(v_pos, 'blue');
hold on;

[lower_cs, upper_cs] = utils.get_splines(v_pos, 0.05);
v_pos = v_pos - lower_cs;

figure(fig);
plot(v_pos, 'red');
hold on;
plot(lower_cs, 'cyan');
ylim([-2,2]);

legend('w/out baseline correction', 'with baseline correction');
xlabel('time (10^{-2} s)');
ylabel('z-position (m)');
title('Z-axis position');

% X-axis orientation, Z-axis acceleration and Z-axis position plot
figure();

yyaxis left;
plot(x_orient, 'blue');
hold on;
plot(v_acc, 'g-');
ylabel('x-orientation / z-acceleration (m/s^2)');

yyaxis right;
plot(v_pos, 'red');

legend('X-orientation', 'Z-acceleration', 'Z-position');
xlabel('time (10^{-2} s)');
ylabel('z-position (m)');
title('X-orientation vs Z-position vs Z-acceleration');

%% Phases analysis and table representation

data = utils.phases_analysis(v_acc, v_vel, v_pos, x_orient);
data.total_cycles                   % number of sit-stand cycles within 30 seconds
t_imp = struct2table(data.imp)      % impulse phase parameters represented as table
t_up = struct2table(data.up)        % stand-up phase parameters represented as table
t_down = struct2table(data.down)    % sit-down phase parameters represented as table
