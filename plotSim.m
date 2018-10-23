
figure;
subplot(2,1,1); 
errorbar(sim.mn_ss1,sim.sem_ss1,'b'); hold on;
errorbar(sim.mn_ss2,sim.sem_ss2,'r'); 
ylim([0.14 0.22])
xlabel('Sample');
ylabel('Mean CTF Selectivity'); 

subplot(2,1,2); 
errorbar(sim.mn_diff,sim.sem_diff); 
hold on;
plot(0:sim.nSamps,zeros(sim.nSamps+1,1),'--k');
xlabel('Sample');
ylabel('Diff in Selectivity'); 
ylim([-.05 .05])


mean_of_mean_diffs = mean(sim.mn_diff)

sigSamps = length(sim.pval(sim.pval < .05))/length(sim.pval)
sigSamps = length(sim.pval(sim.pval < .05 & sim.mn_diff < 0))/length(sim.pval)
sigSamps = length(sim.pval(sim.pval < .05 & sim.mn_diff > 0))/length(sim.pval)