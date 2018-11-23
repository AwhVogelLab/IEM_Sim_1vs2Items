function runSimulation(nSamps,ss1_amp,ss2_amp,e_noise,dat_tuningwidth)

% inputs:
% nSamps: number of samples to run (we do 10,000 but this will take a few hours)
% ss1_amp: amplitude of the underlying tuning functions in the one-item cond (use 1 by default)
% ss2_amp: amplitude of the underlying tuning functions in the two-item cond
% e_noise: sd of gaussian noise applied to each "electrode"
% dat_tuningwidth: sin power that specifies tuning width of simulated data
% (good default is 25, which matches the basis function of our encoding model analysis)

% seed the random generator
rng default % sets the generator to twister and sets the seed to 0 (as in matlab restarted)
rng shuffle % generates a new seed based on the clock
sim.rngSettings = rng; % save to p-struct

nSubsPerSamp = 28; % to match our sample

fname = ['Sim1vs2_',num2str(nSamps),'Samps_SS1amp',num2str(ss1_amp),'_SS2amp',num2str(ss2_amp),'_Noise',num2str(e_noise),'_DatTuning',num2str(dat_tuningwidth),'.mat'];

pval = nan(nSamps,1); 
tstat = nan(nSamps,1); 
mn_diff = nan(nSamps,1); 
sem_diff = nan(nSamps,1); 
mn_ss1 = nan(nSamps,1);
sem_ss1 = nan(nSamps,1);
mn_ss2 = nan(nSamps,1); 
sem_ss2 = nan(nSamps,1); 
mn_ctf_ss1 = nan(nSamps,9);
mn_ctf_ss2 = nan(nSamps,9); 

for s = 1:nSamps
    fprintf('Sample = %d\n',s);
    tic
    [pval(s) tstat(s) mn_diff(s) sem_diff(s) mn_ss1(s) sem_ss1(s) mn_ss2(s) sem_ss2(s) mn_ctf_ss1(s,:) mn_ctf_ss2(s,:)] = simulateSample(nSubsPerSamp,ss1_amp,ss2_amp,e_noise,dat_tuningwidth,0);
    toc 
end

sim.nSamps = nSamps;
sim.nSubsPerSamp = nSubsPerSamp; 
sim.ss1_amp = ss1_amp;
sim.ss2_amp = ss2_amp;
sim.e_noise = e_noise;
sim.dat_tuningwidth = dat_tuningwidth; 
sim.pval = pval;
sim.tstat = tstat; 
sim.mn_diff = mn_diff;
sim.sem_diff = sem_diff;
sim.mn_ss1 = mn_ss1;
sim.sem_ss1 = sem_ss1;
sim.mn_ss2 = mn_ss2; 
sim.sem_ss2 = sem_ss2; 
sim.mn_ctf_ss1 = mn_ctf_ss1;
sim.mn_ctf_ss2 = mn_ctf_ss2;
save(fname,'sim')