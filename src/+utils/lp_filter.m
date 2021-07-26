function filtered = lp_filter(func, fc, fs)
% filtered = lp_filter(func, fc, fs) returns a filtered signal
% by performing a lowpass filtering on the original signal 'func'
% through a Butterworth filter.

%   func - original signal to filter.
%   fc - cut-off frequency.
%   fs - sampling frequency of the original signal.
%   filtered - filtered signal.
    [n, Wn] = buttord(0.01, fc/(fs/2), 3, 60);
    [b,a] = butter(n, fc/(fs/2), 'low');
    filtered = filter(b,a,func);
end

