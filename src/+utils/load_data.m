function [acceleration, orientation, angVel] = load_data(filename)
% [acceleration, orientation, angVel] = load_data(filename) reads a file
% containing previously collected data and returns three signals.

%   acceleration - acceleration signal containing XYZ components.
%   orientation - orientation signal containing XYZ components.
%   angVel - angular velocity signal containing XYZ components.

    data = load(strcat("..//MobileSensorData//", filename));
    acceleration = horzcat(data.Acceleration.X, data.Acceleration.Y, data.Acceleration.Z);
    orientation = horzcat(data.Orientation.X, data.Orientation.Y, data.Orientation.Z);
    angVel = horzcat(data.AngularVelocity.X, data.AngularVelocity.Y, data.AngularVelocity.Z);
    
    % Adjust data length
    min_length = min(length(orientation(:,1)), length(acceleration(:,1)));
    min_length = min(min_length, length(angVel(:,1)));
    orientation = orientation(1:min_length,:);
    acceleration = acceleration(1:min_length,:);
    angVel = angVel(1:min_length,:);
end