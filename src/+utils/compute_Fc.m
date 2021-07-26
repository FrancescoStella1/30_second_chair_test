function Fc = compute_Fc(signal, Fs)
% Fc = compute_Fc(signal, Fs) returns a cut-off frequency for the given
% signal. A threshold is applied to the Fourier Transform of the signal in order to detect
% frequencies with magnitude greater than the threshold and properly choose
% a cut-off frequency.

%   signal - input signal.
%   Fs - sampling frequency of the given signal.
%   Fc - cut-off frequency for the given signal.

    nfft = length(signal);
    nfft2 = 2.^nextpow2(nfft);
    y = fft(signal, nfft2);
    y = y(1:nfft2/2);                                              % consider only the positive axis
    xfft = Fs.*(0:nfft2/2-1)/nfft2;
    y = abs(y/max(y));                                             % normalize
    [pks, locs] = findpeaks(y, xfft, 'MinPeakProminence', 0.3);    % consider only magnitudes above a customizable threshold
    figure();
    plot(xfft,y);
    hold on;
    plot(locs, pks, 'g*');
    
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    title('Fourier Transform of the z-axis acceleration');
    Fc = locs(length(locs)) + 1;
end

