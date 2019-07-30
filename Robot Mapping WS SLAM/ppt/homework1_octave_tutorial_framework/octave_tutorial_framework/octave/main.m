% This script runs the main loop and calls all the required
% functions in the correct order.
%
% You can disable the plotting or change the number of steps the filter
% runs for to ease the debugging. You should however not change the order
% or calls of any of the other lines, as it might break the framework.
%
% If you are unsure about the input and return values of functions you
% should read their documentation which tells you the expected dimensions.

% Make tools available
addpath('tools');

% Read world data, i.e. landmarks.
landmarks = read_world('../data/world.dat');
% Read sensor readings, i.e. odometry and range-bearing sensor
data = read_data('../data/sensor_data.dat');

% Initialize belief
% x: 3x1 vector representing the robot pose [x; y; theta]
x = zeros(3, 1);

% Iterate over odometry commands and update the robot pose
% according to the motion model
for t = 1:size(data.timestep, 2)

    % Update the pose of the robot based on the motion model
    x = motion_command(x, data.timestep(t).odometry);

    %Generate visualization plots of the current state
    plot_state(x, landmarks, t, data.timestep(t).sensor);

    disp("Current robot pose:")
    disp("x = "), disp(x)
endfor

% Display the final state estimate
disp("Final robot pose:")
disp("x = "), disp(x)
