function data = phases_analysis(v_acc, v_vel, v_pos, x_orient)
% data = phases_analysis(v_acc, v_vel, v_pos, x_orient) performs the analysis of each phase of
% the sit-stand-sit cycles, returning a struct containing the values for some kinematic parameters.

%   v_acc - vertical acceleration signal.
%   v_vel - vertical velocity signal.
%   v_pos - vertical position signal.
%   x_orient - x-axis orientation signal.
%   data - struct containing a field for each kinematic parameter
%                 computed.

    % Prepare output data_struct
    data = utils.initialize_struct();
    
    % Find local maxima for vertical position
    [pos_pks, pos_locs] = findpeaks(v_pos, 'MinPeakProminence', 0.15);
    
    % Find local minima for vertical position within 30 seconds
    TF_pos = islocalmin(v_pos(1:3000), 'MinSeparation', 30);
    v_pos_min = find(TF_pos);
    
    valid_pos_pks = find(pos_locs<3000);
    data.total_cycles = length(valid_pos_pks);
    lb_idx=1;    
    lb=v_pos_min(lb_idx);
    ub=lb;                                                              % lb and ub are the lower and upper bounds corresponding to a time window of the signal
    
    first_chunk=true;                                                   % flag used to discard first sit-stand-sit cycle
    
    impulse_chunks=0;
    standup_chunks=0;
    sitdown_chunks=0;
    while ub<v_pos_min(length(v_pos_min))
        if ub>3000
            break
        end
        if first_chunk
            while lb<pos_locs(1)
                lb_idx = lb_idx + 1;
                lb = v_pos_min(lb_idx);
            end
            lb_idx = lb_idx + 1;
            lb = v_pos_min(lb_idx);                                                     % discard first sit-stand-sit cycle
            while v_pos(lb)>0.01                                                        % discard local minima above a predefined threshold
                lb_idx=lb_idx+1;
                lb=v_pos_min(lb_idx);
            end
        end
        
        ub_idx=lb_idx+1;
        ub=v_pos_min(ub_idx);
        while v_pos(ub)>0.01 && ub_idx<length(v_pos_min)                                % discard local minima above a predefined threshold
            ub_idx=ub_idx+1;
            ub=v_pos_min(ub_idx);
        end
        if ub_idx>length(v_pos_min)
            break;
        end
        
        ub=v_pos_min(ub_idx);
        mid_peak_idx = find(pos_locs>lb & pos_locs<ub);                                       % index of the z-position peak between lb and ub, that separates stand-up and sit-down phases
        
        if isempty(pos_locs(mid_peak_idx))                                                    % impulse phase
            % Update parameters in data struct
            data.imp.x_orient_mean = data.imp.x_orient_mean + mean(x_orient(lb:ub-1));
            data.imp.v_acc_mean = data.imp.v_acc_mean + mean(v_acc(lb:ub-1));
            data.imp.v_acc_auc = data.imp.v_acc_auc + trapz(lb:ub-1, v_acc(lb:ub-1));
            
            data.imp.v_vel_mean = data.imp.v_vel_mean + mean(v_vel(lb:ub-1));
            [vel_pks, vel_locs] = findpeaks(v_vel(lb:ub-1));
            if max(vel_pks)>data.imp.v_vel_maxpeak
                data.imp.v_vel_maxpeak = max(vel_pks);
            end
            data.imp.v_vel_auc = data.imp.v_vel_auc + trapz(lb:ub-1, v_vel(lb:ub-1));
            
            impulse_chunks = impulse_chunks + 1;
       
        else                                                                             % sit-stand-sit phase
        
            mid_peak = pos_locs(mid_peak_idx(1));                                        % z-position positive peak
            
            % Update parameters in data struct for stand-up phase
            data.up.x_orient_mean = data.up.x_orient_mean + mean(x_orient(lb:mid_peak-1));
            data.up.v_acc_mean = data.up.v_acc_mean + mean(v_acc(lb:mid_peak-1));
            data.up.v_acc_auc = data.up.v_acc_auc + trapz(lb:mid_peak-1, v_acc(lb:mid_peak-1));
            
            data.up.v_vel_mean = data.up.v_vel_mean + mean(v_vel(lb:mid_peak-1));
            
            [vel_pks, vel_locs] = findpeaks(v_vel(lb:mid_peak-1));
            if max(vel_pks)>data.up.v_vel_maxpeak
                data.up.v_vel_maxpeak = max(vel_pks);
            end
            data.up.v_vel_auc = data.up.v_vel_auc + trapz(lb:mid_peak-1, v_vel(lb:mid_peak-1));
            standup_chunks = standup_chunks + 1;
            
            % Update parameters in data struct for sit-down phase
            data.down.x_orient_mean = data.down.x_orient_mean + mean(x_orient(mid_peak:ub-1));
            data.down.v_acc_mean = data.down.v_acc_mean + mean(v_acc(mid_peak:ub-1));
            data.down.v_acc_auc = data.down.v_acc_auc + trapz(mid_peak:ub-1, v_acc(mid_peak:ub-1));
            
            data.down.v_vel_mean = data.down.v_vel_mean + mean(v_vel(mid_peak:ub-1));
            
            v_vel_chunk = v_vel(mid_peak:ub-1);
            TF_down = islocalmin(v_vel_chunk);
            dw_min_idx = find(TF_down);
            dw_min = min(v_vel_chunk(dw_min_idx));
            
            if(abs(dw_min)>data.down.v_vel_maxpeak)
                data.down.v_vel_maxpeak = abs(dw_min);
            end
            
            data.down.v_vel_auc = data.down.v_vel_auc + trapz(mid_peak:ub-1, v_vel(mid_peak:ub-1));
            sitdown_chunks = sitdown_chunks + 1;
        end
        
        lb=ub;
    end
    
    data.imp.x_orient_mean = data.imp.x_orient_mean/impulse_chunks;
    data.imp.v_acc_mean = data.imp.v_acc_mean/impulse_chunks;
    data.imp.v_acc_auc = data.imp.v_acc_auc/(impulse_chunks*100);
    data.imp.v_vel_mean = data.imp.v_vel_mean/impulse_chunks;
    data.imp.v_vel_auc = data.imp.v_vel_auc/(impulse_chunks*100);
    
    data.up.x_orient_mean = data.up.x_orient_mean/standup_chunks;
    data.up.v_acc_mean = data.up.v_acc_mean/standup_chunks;
    data.up.v_acc_auc = data.up.v_acc_auc/(standup_chunks*100);
    data.up.v_vel_mean = data.up.v_vel_mean/standup_chunks;
    data.up.v_vel_auc = data.up.v_vel_auc/(standup_chunks*100);
    
    data.down.x_orient_mean = data.down.x_orient_mean/sitdown_chunks;
    data.down.v_acc_mean = data.down.v_acc_mean/sitdown_chunks;
    data.down.v_acc_auc = data.down.v_acc_auc/(sitdown_chunks*100);
    data.down.v_vel_mean = data.down.v_vel_mean/sitdown_chunks;
    data.down.v_vel_auc = data.down.v_vel_auc/(sitdown_chunks*100);
    
    figure();
    plot(v_pos, 'cyan');
    hold on;
    plot(pos_locs(valid_pos_pks), pos_pks(valid_pos_pks), 'r*');
    plot(v_pos_min, v_pos(TF_pos), 'r*');
    ylim([-0.1,0.8]);
    
    xlabel('time (10^{-2} s)');
    ylabel('z-position (m)');
    title('z-position');
end

