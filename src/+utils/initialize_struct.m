function data = initialize_struct()
% data = initialize_struct() initializes the struct containing some
% relevant kinematic parameters.

%   data - struct containing kinematic parameters for each one of the
%   phases, i.e. impulse/stand-up/sit-down.
    data = struct();
    
    data.total_cycles=0;

    data.imp.x_orient_mean=0;
    data.imp.v_acc_mean=0;
    data.imp.v_acc_auc=0;
    data.imp.v_vel_mean=0;
    data.imp.v_vel_maxpeak=0;
    data.imp.v_vel_auc=0;

    data.up.x_orient_mean=0;
    data.up.v_acc_mean=0;
    data.up.v_acc_auc=0;
    data.up.v_vel_mean=0;
    data.up.v_vel_maxpeak=0;
    data.up.v_vel_auc=0;
    
    data.down.x_orient_mean=0;
    data.down.v_acc_mean=0;
    data.down.v_acc_auc=0;
    data.down.v_vel_mean=0;
    data.down.v_vel_maxpeak=0;
    data.down.v_vel_auc=0;
end

