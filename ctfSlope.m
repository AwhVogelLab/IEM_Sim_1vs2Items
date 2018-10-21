function sl = ctfSlope(tf)

% tf: 8-channel ctf (where 5th chan is chan offset of 0);
% sl: slope of ctf as calculated in Foster et al. (2016) J. Neurophysiol. 

x = 1:5;
y = [tf(1),mean([tf(2),tf(8)]),mean([tf(3),tf(7)]),mean([tf(4),tf(6)]),tf(5)]; % average equidistant chans
fit = polyfit(x,y,1); % do linear regression
sl = fit(1); % grab slope param


