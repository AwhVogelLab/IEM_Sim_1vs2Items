function Wrapper(nCores,nSamps,ss1_amp,ss2_amp,e_noise,dat_tuningwidth)
% wrapper function to run subject level analyses for Figure X 

%% run the analyses

startAcropolis(nCores);

runSimulation(nSamps,ss1_amp,ss2_amp,e_noise,dat_tuningwidth);

stopAcropolis;
