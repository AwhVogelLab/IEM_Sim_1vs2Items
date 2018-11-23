fs = 8;
nShow= 100; % how many samples to plot

FigHandle = figure('Position', [100, 100, 450, 400]); % size of the plot
subplot(2,1,1); 
shadedErrorBar(1:nShow,sim.mn_ss1(1:nShow),sim.sem_ss1(1:nShow),'b'); hold on;
% plot(1:nShow,sim.mn_ss1(1:nShow),'b','LineWidth',1.5)
shadedErrorBar(1:nShow,sim.mn_ss2(1:nShow),sim.sem_ss2(1:nShow),'r');
% plot(1:nShow,sim.mn_ss2(1:nShow),'r','LineWidth',1.5)
xlabel('Sample');
ylabel('CTF Selectivity'); 
set(gca,'FontSize',fs)
set(gca,'FontName','Arial')
ylim([0.14 0.22])

subplot(2,1,2); 
shadedErrorBar(1:nShow,sim.mn_diff(1:nShow),sim.sem_diff(1:nShow)); 
% plot(1:nShow,sim.mn_diff(1:nShow),'k','LineWidth',1.5)
hold on;
plot(1:nShow,zeros(nShow,1),'--k');
xlabel('Sample');
ylabel({'Difference in CTF Selectivity','(one item - two item)'}); 
set(gca,'FontSize',fs)
set(gca,'FontName','Arial')
ylim([-.06 .06])
yticks([-.06 -.03 0 .03 .06])


mean_of_mean_diffs = mean(sim.mn_diff)

% print statistics
alpha = 0.05;
% reg t-test - proportion significant
sigSamps = length(sim.pval(sim.pval < alpha))/length(sim.pval)
% reg t-test - proportion significant and SS1 > SS2
sigSamps = length(sim.pval(sim.pval < alpha & sim.mn_diff < 0))/length(sim.pval)
% reg t-test - proportion significant and SS2 > SS1
sigSamps = length(sim.pval(sim.pval < alpha & sim.mn_diff > 0))/length(sim.pval)