%

nSamps = 5000; % number of times to run the simulation
nSubsPerSamp = 28; 
SS1_amp = 1;
SS2_amp = 1;
e_noise = 0;


pval = nan(nSamps,1);
mn_diff = nan(nSamps,1); 
mn_SS1 = nan(nSamps,1);
mn_SS2 = nan(nSamps,1); 

for s = 1:nSamps
    fprintf('Sample = %d\n',s);
    tic
    [pval(s) mn_diff(s) mn_ss1(s) mn_ss2(s)] = simulateSample(nSubsPerSamp,SS1_amp,SS2_amp,e_noise,0);
    toc 
end


sim.pval = pval;
sim.mn_diff = mn_diff;
sim.mn_ss1 = mn_ss1;
sim.mn_ss2 = mn_ss2; 
save('Sim.mat','sim')





