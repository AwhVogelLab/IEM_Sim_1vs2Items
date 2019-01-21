function ClusterWrapper(nCores,nSamps,ss1_amp,ss2_amp,ss1_noise,ss2_noise,dat_tuningwidth)
% This is a wrapper we use to run the analysis on our cluster. You may or
% may not want to use this. You can also just run the simulation locally
% with the "runSimulation" function. 

%% run the analyses

startAcropolis(nCores);

runSimulation(nSamps,ss1_amp,ss2_amp,ss1_noise,ss2_noise,dat_tuningwidth);

stopAcropolis;
