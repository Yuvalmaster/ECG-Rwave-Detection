function [R_peaks] = Rwave_detection(signal,PLFREQ)
%% =============Load data and convert to vectors=============== %%
signal = struct2array(signal);

%% ====================Filtering data========================== %%

signal_filtered = Filter_sig(signal,PLFREQ);

%% =========Setting threshold and applSying to signal========== %%
%Using AF2 algorithm from the article shown at the assignment instructions

thresh=0.4.*max(signal_filtered); %Setting threshold
leveled_signal=abs(signal_filtered); %abs the signal

below_thresh=leveled_signal<thresh;
leveled_signal(below_thresh)=thresh; %Leveling every point below threshold to threshold level

%% ============Calculating derivetive and detection============ %%
d_signal=[]; %first derivetive
for i=2:(length(leveled_signal)-1)
   d_signal=[d_signal (leveled_signal(i+1)-leveled_signal(i-1))];
end

R_loc=find(d_signal>0); %threshold for QRS detection

%% ==============Improve detection to R_peaks================== %%
%The rationale behind improving the detection is that the algorithm is detecting QRS, 
%and not specifically the peaks. The R_peaks vector takes the furthest location in a group 
%of each consecutive number and locates the nearest maximum value in the area (where the Incline is closest to 0.7 again).
%Then, the algorithm search in the area of 60 points around the max values detected for higher 
%amplitude (if exist), and declare that point as the peak. 
%To stay in signal length, conditions set to verify the R_peaks is in range of the length of the signal.

R_peaks = R_loc([diff(R_loc)~=1,true]);
for i=1:length(R_peaks)
    if R_peaks(i)+30>length(signal_filtered)
        y=flip(0:29);
        for j=1:length(y)
            if R_peaks(i)+y(j)<=length(signal_filtered)
                [~,MAX_loc]=max(signal_filtered((R_peaks(i)-30):(R_peaks(i)+y(j))));
                R_peaks(i)=R_peaks(i)+MAX_loc-31; %Compansate for group delay and phase of the filters by choosing the index of the raw signal
                
                break
            end
        end
    elseif R_peaks(i)-30<1
        y=flip(0:29);
        for p=1:length(y)
            if R_peaks(i)+y(p)>=length(signal_filtered)
                [~,MAX_loc]=max(signal_filtered((R_peaks(i)-y(p)):(R_peaks(i)+30)));
                R_peaks(i)=R_peaks(i)+MAX_loc-31+p; %Compansate for group delay and phase by the filters
                
                break
            end
        end
    else
        [~,MAX_loc]=max(signal_filtered((R_peaks(i)-30):(R_peaks(i)+30)));
        R_peaks(i)=R_peaks(i)+MAX_loc-30; %Compansate for group delay and phase by the filters
         
    end
end

end