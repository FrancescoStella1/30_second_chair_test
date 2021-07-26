function [lower_cs, upper_cs] = get_splines(signal, min_prominence)
% [lower_cs, upper_cs] = get_splines(signal, min_prominence)
% computes lower and upper cubic splines for the given signal.

%   signal - original signal.
%   min_prominence - min_prominence parameter for the local minima to consider.
%   lower_cs - lower cubic spline for the signal.
%   upper_cs - upper cubic spline for the signal.
    TF = islocalmin(signal, 'MinProminence', min_prominence);
    minima = find(TF);
    [maxima, maxima_locs] = findpeaks(signal);
    
    x = linspace(0, length(signal), length(signal));
    lower_cs = spline(minima, [0 signal(TF) 0], x);
    upper_cs = spline(maxima_locs, [0 maxima 0], x);
end

