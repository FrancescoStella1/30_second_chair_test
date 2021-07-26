function [est_orientation_quat, est_angVel] = apply_fusion(acceleration, angVel)
% [est_orientation_quat, est_angVel] = apply_fusion(acceleration, angVel)
% applies a fusion algorithm starting from acceleration and angular
% velocity signals. It returns an estimated orientation quaternion together
% with estimated angular velocity.

%   acceleration - acceleration signal containing XYZ components.
%   angVel - angular velocity containing XYZ components.
%   est_orientation_quat - quaternion representing estimated orientation to
%                          apply to the reference frame.
%   est_angVel - estimated angular velocity.
    FUSE = imufilter('ReferenceFrame', 'NED');      % sample rate default to 100 Hz
    [est_orientation_quat, est_angVel] = FUSE(acceleration, angVel);
end

