clear all ; close all ; clc ;
tic
%% Load Data
mainpath = pwd;

addpath(strcat(mainpath,'\Functions'))

ecg1y=load(strcat(mainpath,'\Data\ECG_1_01.mat'));
ecg2y=load(strcat(mainpath,'\Data\ECG_1_02.mat'));
ecg1m=load(strcat(mainpath,'\Data\ECG_2_01.mat'));
ecg2m=load(strcat(mainpath,'\Data\ECG_2_02.mat'));

ecg = [ecg1y ecg2y ecg1m ecg2m];
ecgnames= ['ECG 1 01';'ECG 1 02';'ECG 2 01';'ECG 2 02'];
%% ##################### 1 ########################### %% 

% Transform signal to vector 
signal1 = struct2array(ecg(1));
signal2 = struct2array(ecg(2));

% Define PLFREQ for signal1
Fs=1000;
[pxx1,f1] = pwelch(signal1,[],[],[],Fs,'power'); 
Max_interference_loc=find((f1>=30 & f1<=70));
[~,loc_freq]=max(pow2db(pxx1(Max_interference_loc)));
PLFREQ1 = f1(loc_freq+Max_interference_loc(1));

% Define PLFREQ for signal2
[pxx1,f1] = pwelch(signal2,[],[],[],Fs,'power'); 
Max_interference_loc=find((f1>=30 & f1<=70));
[~,loc_freq]=max(pow2db(pxx1(Max_interference_loc)));
PLFREQ2 = f1(loc_freq+Max_interference_loc(1));

% Find peaks
Rwaves.R1 = Rwave_detection(ecg1y,PLFREQ1); %R1 = index of R waves in ecg1
Rwaves.R2 = Rwave_detection(ecg2y,PLFREQ2); %R2 = index of R waves in ecg2

%%===============Plot results==========================%%     
%%% Signal1 %%%
t1=1:length(signal1); %Signal time (in msec)
figure; plot(t1,signal1); hold on ;   
scatter(Rwaves.R1,signal1(Rwaves.R1),24,'filled','r')    
title("Sample [ "+ecgnames(1,:)+" ]"); xlabel('[msec]'); ylabel('[\muV]');
grid on;

%Plot signal1 between 30 to 38 sec, with/without peaks detection
filtered_signal1=Filter_sig(signal1,PLFREQ1);
figure; subplot(2,1,1); plot(t1,signal1); xlim([30000 38000]); xlabel('[msec]'); ylabel('[\muV]');
title("Sample [ "+ecgnames(1,:)+" ]"+" Unfiltered"); grid on;
subplot(2,1,2); plot(t1,filtered_signal1); xlim([30000 38000]); xlabel('[msec]'); ylabel('[\muV]');
title("Sample [ "+ecgnames(1,:)+" ]"+" Filtered"); grid on;


filtered_R_peaks1=[];
for i=1:length(Rwaves.R1)
    if Rwaves.R1(i)+30>length(filtered_signal1)
        y=flip(0:29);
        for j=1:length(y)
            if Rwaves.R1(i)+y(j)<=length(filtered_signal1)
                [~,MAX_loc]=max(filtered_signal1((Rwaves.R1(i)-30):(Rwaves.R1(i)+y(j))));
                filtered_R_peaks1(i)=Rwaves.R1(i)+MAX_loc-31; 
                
                break
            end
        end
    elseif Rwaves.R1(i)-30<1
        y=flip(0:29);
        for p=1:length(y)
            if Rwaves.R1(i)-y(p)>=1
                [~,MAX_loc]=max(filtered_signal1((Rwaves.R1(i)-y(p)):(Rwaves.R1(i)+30)));
                filtered_R_peaks1(i)=Rwaves.R1(i)+MAX_loc-31+p; 
                
                break
            end
        end
    else
        [~,MAX_loc]=max(filtered_signal1((Rwaves.R1(i)-30):(Rwaves.R1(i)+30)));
        filtered_R_peaks1(i)=Rwaves.R1(i)+MAX_loc-31; 
         
    end
end

figure; subplot(2,1,1); plot(t1,signal1); hold on;
scatter(Rwaves.R1,signal1(Rwaves.R1),24,'filled','r'); xlim([30000 38000]); xlabel('[msec]'); ylabel('[\muV]');
title("Sample [ "+ecgnames(1,:)+" ]"+" Unfiltered: /w Peak detection"); grid on;
subplot(2,1,2); plot(t1,filtered_signal1); hold on;
scatter(filtered_R_peaks1,filtered_signal1(filtered_R_peaks1),24,'filled','r'); xlim([30000 38000]); xlabel('[msec]'); ylabel('[\muV]');
title("Sample [ "+ecgnames(1,:)+" ]"+" Filtered: /w Peak detection"); grid on;

%%% Signal2 %%%
t2=1:length(signal2); %Signal time (in msec)
figure; plot(t2,signal2); hold on ;   
scatter(Rwaves.R2,signal2(Rwaves.R2),24,'filled','r')    
title("Sample [ "+ecgnames(2,:)+" ]"); xlabel('[msec]'); ylabel('[\muV]');
grid on;

%Plot signal1 between 30 to 38 sec, with/without peaks detection
filtered_signal2=Filter_sig(signal2,PLFREQ2);
figure; subplot(2,1,1); plot(t2,signal2); xlim([30000 38000]);
xlabel('[msec]'); ylabel('[\muV]'); title("Sample [ "+ecgnames(2,:)+" ]"+" Unfiltered"); grid on;
subplot(2,1,2); plot(t2,filtered_signal2); xlim([30000 38000]);
xlabel('[msec]'); ylabel('[\muV]'); title("Sample [ "+ecgnames(2,:)+" ]"+" Filtered"); grid on;

filtered_R_peaks2=[];
for i=1:length(Rwaves.R2)
    if Rwaves.R2(i)+30>length(filtered_signal2)
        y=flip(0:29);
        for j=1:length(y)
            if Rwaves.R2(i)+y(j)<=length(filtered_signal2)
                [~,MAX_loc]=max(filtered_signal2((Rwaves.R2(i)-30):(Rwaves.R2(i)+y(j))));
                filtered_R_peaks2(i)=Rwaves.R2(i)+MAX_loc-31; 
                
                break
            end
        end
    elseif Rwaves.R1(i)-30<1
        y=flip(0:29);
        for p=1:length(y)
            if Rwaves.R2(i)-y(p)>=1
                [~,MAX_loc]=max(filtered_signal2((Rwaves.R2(i)-y(p)):(Rwaves.R2(i)+30)));
                filtered_R_peaks2(i)=Rwaves.R2(i)+MAX_loc-31+p; 
                
                break
            end
        end
    else
        [~,MAX_loc]=max(filtered_signal2((Rwaves.R2(i)-30):(Rwaves.R2(i)+30)));
        filtered_R_peaks2(i)=Rwaves.R2(i)+MAX_loc-31; 
         
    end
end

figure; subplot(2,1,1); plot(t2,signal2); hold on;
scatter(Rwaves.R2,signal2(Rwaves.R2),24,'filled','r'); xlim([30000 38000]); xlabel('[msec]'); ylabel('[\muV]');
title("Sample [ "+ecgnames(2,:)+" ]"+" Unfiltered: /w Peak detection"); grid on;
subplot(2,1,2); plot(t2,filtered_signal2); hold on;
scatter(filtered_R_peaks2,filtered_signal2(filtered_R_peaks2),24,'filled','r'); xlim([30000 38000]);
xlabel('[msec]'); ylabel('[\muV]'); title("Sample [ "+ecgnames(2,:)+" ]"+" Filtered: /w Peak detection"); grid on;
    
% HR Signal2 - Plot Beat per second over time
Peak_dist=diff(Rwaves.R2)./1000; %time between peaks in seconds
HR_2=NaN(1,length(signal2));
HR_2(1:Rwaves.R2(1))=Peak_dist(1);
HR_2(Rwaves.R2(end):length(signal2))=Peak_dist(end);
for i=1:length(Rwaves.R2)-1
    if Peak_dist(i)<0.125 %highest record HR is 480BPM. cutting anything above. (In case of false detections)
        HR_2(Rwaves.R2(i):Rwaves.R2(i+1))=NaN;
    else
        HR_2(Rwaves.R2(i):Rwaves.R2(i+1))=Peak_dist(i);
    end
end
     
t_dist1=linspace(1,(length(signal2)/1000),length(signal2));
figure; plot(t_dist1,1./HR_2);
title("Sample [ "+ecgnames(2,:)+"] : Beats per second Over time"); xlabel('[sec]'); ylabel('[beat/sec]'); grid on;

%Find average HR of the signal
Peak_dist=Peak_dist(Peak_dist>0.125);
HR_Signal2 = 60/(mean(Peak_dist)); %Heart Rate
disp(append('Mean Heart rate of signal - ',ecgnames(2,:),': ',num2str(HR_Signal2), ' BPM'))



%Save R-wave detections for all signals
save('1.mat','Rwaves');


%% ##################### 2 ######################### %% 

% Transform signal to vector 
signal1 = struct2array(ecg(3));
signal2 = struct2array(ecg(4));

% Define PLFREQ for signal1
[pxx1,f1] = pwelch(signal1,[],[],[],Fs,'power'); 
Max_interference_loc=find((f1>=30 & f1<=70));
[~,loc_freq]=max(pow2db(pxx1(Max_interference_loc)));
PLFREQ1 = f1(loc_freq+Max_interference_loc(1));

% Define PLFREQ for signal2
[pxx1,f1] = pwelch(signal2,[],[],[],Fs,'power'); 
Max_interference_loc=find((f1>=30 & f1<=70));
[~,loc_freq]=max(pow2db(pxx1(Max_interference_loc)));
PLFREQ2 = f1(loc_freq+Max_interference_loc(1));

% Find peaks
Rwaves.R1 = Rwave_detection(ecg1m,PLFREQ1); %R1 = index of R waves in ecg1
Rwaves.R2 = Rwave_detection(ecg2m,PLFREQ2); %R2 = index of R waves in ecg2

%%===============Plot results==========================%%     
%%% Signal1 %%%
t1=1:length(signal1); %Signal time (in msec)
figure; plot(t1,signal1); hold on ;   
scatter(Rwaves.R1,signal1(Rwaves.R1),24,'filled','r')    
title("Sample [ "+ecgnames(3,:)+" ]"); xlabel('[msec]'); ylabel('[\muV]');
grid on;

%Plot signal1 between 30 to 38 sec, with/without peaks detection
filtered_signal1=Filter_sig(signal1,PLFREQ1);
figure; subplot(2,1,1); plot(t1,signal1); xlim([30000 38000]); xlabel('[msec]'); ylabel('[\muV]');
title("Sample [ "+ecgnames(3,:)+" ]"+" Unfiltered"); grid on;
subplot(2,1,2); plot(t1,filtered_signal1); xlim([30000 38000]); xlabel('[msec]'); ylabel('[\muV]');
title("Sample [ "+ecgnames(3,:)+" ]"+" Filtered"); grid on;

filtered_R_peaks1=[];
for i=1:length(Rwaves.R1)
    if Rwaves.R1(i)+30>length(filtered_signal1)
        y=flip(0:29);
        for j=1:length(y)
            if Rwaves.R1(i)+y(j)<=length(filtered_signal1)
                [~,MAX_loc]=max(filtered_signal1((Rwaves.R1(i)-30):(Rwaves.R1(i)+y(j))));
                filtered_R_peaks1(i)=Rwaves.R1(i)+MAX_loc-31; 
                
                break
            end
        end
    elseif Rwaves.R1(i)-30<1
        y=flip(0:29);
        for p=1:length(y)
            if Rwaves.R1(i)-y(p)>=1
                [~,MAX_loc]=max(filtered_signal1((Rwaves.R1(i)-y(p)):(Rwaves.R1(i)+30)));
                filtered_R_peaks1(i)=Rwaves.R1(i)+MAX_loc-31+p; 
                
                break
            end
        end
    else
        [~,MAX_loc]=max(filtered_signal1((Rwaves.R1(i)-30):(Rwaves.R1(i)+30)));
        filtered_R_peaks1(i)=Rwaves.R1(i)+MAX_loc-31; 
         
    end
end

figure; subplot(2,1,1); plot(t1,signal1); hold on;
scatter(Rwaves.R1,signal1(Rwaves.R1),24,'filled','r'); xlim([30000 38000]); xlabel('[msec]'); ylabel('[\muV]');
title("Sample [ "+ecgnames(3,:)+" ]"+" Unfiltered: /w Peak detection"); grid on;
subplot(2,1,2); plot(t1,filtered_signal1); hold on;
scatter(filtered_R_peaks1,filtered_signal1(filtered_R_peaks1),24,'filled','r'); xlim([30000 38000]); xlabel('[msec]'); ylabel('[\muV]');
title("Sample [ "+ecgnames(3,:)+" ]"+" Filtered: /w Peak detection"); grid on;

%%% Signal2 %%%
t2=1:length(signal2); %Signal time (in msec)
figure; plot(t2,signal2); hold on ;   
scatter(Rwaves.R2,signal2(Rwaves.R2),24,'filled','r')    
title("Sample [ "+ecgnames(4,:)+" ]"); xlabel('[msec]'); ylabel('[\muV]');
grid on;

%Plot signal1 between 30 to 38 sec, with/without peaks detection
filtered_signal2=Filter_sig(signal2,PLFREQ2);
figure; subplot(2,1,1); plot(t2,signal2); xlim([30000 38000]);
xlabel('[msec]'); ylabel('[\muV]'); title("Sample [ "+ecgnames(4,:)+" ]"+" Unfiltered"); grid on;
subplot(2,1,2); plot(t2,filtered_signal2); xlim([30000 38000]);
xlabel('[msec]'); ylabel('[\muV]'); title("Sample [ "+ecgnames(4,:)+" ]"+" Filtered"); grid on;

filtered_R_peaks2=[];
for i=1:length(Rwaves.R2)
    if Rwaves.R2(i)+30>length(filtered_signal2)
        y=flip(0:29);
        for j=1:length(y)
            if Rwaves.R2(i)+y(j)<=length(filtered_signal2)
                [~,MAX_loc]=max(filtered_signal2((Rwaves.R2(i)-30):(Rwaves.R2(i)+y(j))));
                filtered_R_peaks2(i)=Rwaves.R2(i)+MAX_loc-31; 
                
                break
            end
        end
    elseif Rwaves.R1(i)-30<1
        y=flip(0:29);
        for p=1:length(y)
            if Rwaves.R2(i)-y(p)>=1
                [~,MAX_loc]=max(filtered_signal2((Rwaves.R2(i)-y(p)):(Rwaves.R2(i)+30)));
                filtered_R_peaks2(i)=Rwaves.R2(i)+MAX_loc-31+p; 
                
                break
            end
        end
    else
        [~,MAX_loc]=max(filtered_signal2((Rwaves.R2(i)-30):(Rwaves.R2(i)+30)));
        filtered_R_peaks2(i)=Rwaves.R2(i)+MAX_loc-31; 
         
    end
end

figure; subplot(2,1,1); plot(t2,signal2); hold on;
scatter(Rwaves.R2,signal2(Rwaves.R2),24,'filled','r'); xlim([30000 38000]); xlabel('[msec]'); ylabel('[\muV]');
title("Sample [ "+ecgnames(4,:)+" ]"+" Unfiltered: /w Peak detection"); grid on;
subplot(2,1,2); plot(t2,filtered_signal2); hold on;
scatter(filtered_R_peaks2,filtered_signal2(filtered_R_peaks2),24,'filled','r'); xlim([30000 38000]);
xlabel('[msec]'); ylabel('[\muV]'); title("Sample [ "+ecgnames(4,:)+" ]"+" Filtered: /w Peak detection"); grid on;
    
% HR Signal2 - Plot Beat per second over time
Peak_dist=diff(Rwaves.R2)./1000; %time between peaks in seconds
HR_2=NaN(1,length(signal2));
HR_2(1:Rwaves.R2(1))=Peak_dist(1);
HR_2(Rwaves.R2(end):length(signal2))=Peak_dist(end);
for i=1:length(Rwaves.R2)-1
    if Peak_dist(i)<0.125 %highest record HR is 480BPM. cutting anything above. (In case of false detections)
            
        HR_2(Rwaves.R2(i):Rwaves.R2(i+1))=NaN;
    else
        HR_2(Rwaves.R2(i):Rwaves.R2(i+1))=Peak_dist(i);
    end
end
     
t_dist1=linspace(1,(length(signal2)/1000),length(signal2));
figure; plot(t_dist1,1./HR_2);
title("Sample [ "+ecgnames(4,:)+"] : Beats per second Over time"); xlabel('[sec]'); ylabel('[beat/sec]'); grid on;

%Find average HR of the signal
Peak_dist=Peak_dist(Peak_dist>0.125);
HR_Signal2 = 60/(mean(Peak_dist)); %Heart Rate
disp(append('Mean Heart rate of signal - ',ecgnames(4,:),': ',num2str(HR_Signal2), ' BPM'))



%Save R-wave detections for all signals
save('2.mat','Rwaves');





toc

