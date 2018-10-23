function [p, p_ttest, mn_diff, sem_diff, mn_ss1, sem_ss1, mn_ss2, sem_ss2, mn_CTF_SS1, mn_CTF_SS2] = simulateSample(nSubs,SS1_amp,SS2_amp,e_noise,dat_tuningwidth,plotDat)

% inputs:
% nSubs = number of "subjects" in sample
% SS1_amp = amplitude of simulated tuning in SS1 condition
% SS2_amp = amp of simulated tuning in SS2 conditon
% e_noise = electrode noise
% plotDat: 0 = plot the data, 1 = don't plot the data

% preallocate matrices
SS1_CTF = nan(nSubs,8); SS2_CTF = SS1_CTF;
SS1_sl = nan(nSubs,1); SS2_sl = SS1_sl; 

%% simulate data for each sub and apply IEM analysis
parfor s = 1:nSubs
    [SS1_CTF(s,:) SS2_CTF(s,:) SS1_sl(s) SS2_sl(s)] = sim_1vs2Items(e_noise,SS1_amp,SS2_amp,dat_tuningwidth);
end

%% plot data
mn_CTF_SS1 = mean(SS1_CTF); mn_CTF_SS1(9) = mn_CTF_SS1(1);
sem_CTF_SS1 = std(SS1_CTF)./sqrt(nSubs); sem_CTF_SS1(9) = sem_CTF_SS1(1);
mn_CTF_SS2 = mean(SS2_CTF); mn_CTF_SS2(9) = mn_CTF_SS2(1);
sem_CTF_SS2 = std(SS2_CTF)./sqrt(nSubs); sem_CTF_SS2(9) = sem_CTF_SS2(1);
x = -180:45:180; % values for x-axis
if plotDat == 1
    figure;
    errorbar(x,mn_CTF_SS1,sem_CTF_SS1,'b','LineWidth',1.5); hold on;
    errorbar(x,mn_CTF_SS2,sem_CTF_SS2,'r','LineWidth',1.5);
    xlabel('Channel Offset (°)')
    ylabel('Channel Response');
    xticks(-180:90:180)
    xlim([-200 200])
end

%% calculate mean slope values
mn_ss1 = mean(SS1_sl); 
mn_ss2 = mean(SS2_sl); 
mn_diff = mn_ss1-mn_ss2; % difference of means


%% do bootstrap resampling test

bIter = 100000; % do 100,000 bootstrap samples (as in our analyses)

ss1_mn_sl = nan(bIter,1);
ss2_mn_sl = nan(bIter,1); 

for b = 1:bIter
    [sl, idx] = datasample(SS1_sl,nSubs,1);    
    ss1_mn_sl(b) = mean(sl);
    sl = SS2_sl(idx,:); 
    ss2_mn_sl(b) = mean(sl);  
end

diff = ss1_mn_sl-ss2_mn_sl;  % difference of means for each bootstrap sample
sem_diff = std(diff); 
sem_ss1 = std(ss1_mn_sl);
sem_ss2 = std(ss2_mn_sl); 
p1 = length(diff(diff < 0))/length(diff); % left tail
p2 = length(diff(diff > 0))/length(diff); % right tail

% multiple the smaller p-value by 2 to get the two-sided value
if p1 < p2
    p = 2*p1;
elseif p2 < p1
    p = 2*p2;
elseif p1 == p2
    p = p1;
end

% do regular t-test
[h p_ttest] = ttest(SS1_sl,SS2_sl); 


