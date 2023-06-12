function signal_filtered =Filter_sig(signal,PLFREQ)

Fs=1000;        % Sampling frequency [Hz]

% Notch filter to mitigate breathing noises of 130 breaths a minute
[b, a] = iirnotch((130/60)/(Fs/2),(130/60)/(Fs/2)/35);
filtered_signal=filtfilt(b,a,signal); % Compansate for delay

% Filter the signal by 60 [dB] between frequencies of 3-70 [Hz] (cut noises
% due to muscle movements, sweating and artifacts that affect low
% frequencies and cut high frequencies that may introduce noises while
% preserving the EEG signal.
filtered_signal=bandpass(filtered_signal,[3,70],Fs,"ImpulseResponse","auto");

% Cut PLFREQ usinng notch filter (An artificial noise that appear between 30-70 [Hz]) 
[b, a] = iirnotch(PLFREQ/(Fs/2),PLFREQ/(Fs/2)/35);
filtered_signal=filtfilt(b,a,filtered_signal); % Compansate for delay

% The last filter stables the amplitude of the signal more evenly, lowering
% high peaks.
[b1,a1]=cheby2(8,80,PLFREQ/(Fs/2)); %chebychev type II. 80dB reduction of stopbands attenuation, 8th order poles. 
signal_filtered=filtfilt(b1,a1,filtered_signal);

end