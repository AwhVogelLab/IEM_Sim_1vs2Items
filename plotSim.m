%% plot simulation results
% first load simulation data file, then run this script to plot. 

FigHandle = figure('Position', [100, 100, 700, 180]); % size of the plot

% plot settings
fs = 8; % font size
binwidth = 0.0004; % bin width for histograms
facealpha = 0.5; % transparency

%% plot mean CTF selectivity for each condition
ymax = 1500; 
edges = [0.14:binwidth:0.20]; % hist bin edges
subplot(1,2,1);
histogram(sim.mn_ss2,edges,'EdgeColor','none','FaceColor','r','FaceAlpha',facealpha); hold on;
histogram(sim.mn_ss1,edges,'EdgeColor','none','FaceColor','b','FaceAlpha',facealpha); 
xlabel('CTF Selectivity')
ylabel('# Samples')
ylim([0 ymax])
set(gca,'FontSize',fs)
set(gca,'FontName','Arial')
x = [mean(sim.mn_ss2) mean(sim.mn_ss2)];
y = [0 ymax]
plot(x,y,'r','LineStyle','--'); % plot mean marker SS2
x = [mean(sim.mn_ss1) mean(sim.mn_ss1)];
plot(x,y,'b','LineStyle','--'); % plot mean marker SS1

%% plot mean difference in CTF selectivity (SS1 - SS2)
ymax = 1000;
edges = [-.03:binwidth:0.03]
subplot(1,2,2)
histogram(sim.mn_diff,edges,'EdgeColor','none','FaceColor','k'); hold on;
xlabel('Difference in CTF Selectivity')
ylabel('# Samples')
ylim([0 ymax])
set(gca,'FontSize',fs)
set(gca,'FontName','Arial')
mean_of_mean_diffs = mean(sim.mn_diff);
x = [mean_of_mean_diffs mean_of_mean_diffs];
y = [0 ymax]
plot(x,y,'k','LineStyle','--'); % plot mean marker

% print statistics
alpha = 0.05;
% reg t-test - proportion significant
sigSamps = length(sim.pval(sim.pval < alpha))/length(sim.pval)
% reg t-test - proportion significant and SS1 > SS2
sigSamps = length(sim.pval(sim.pval < alpha & sim.mn_diff > 0))/length(sim.pval)
% reg t-test - proportion significant and SS2 > SS1
sigSamps = length(sim.pval(sim.pval < alpha & sim.mn_diff < 0))/length(sim.pval)