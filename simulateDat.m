function [d_n,posBin1,posBin2] = simulateDat(ss,nTrials,amp,e_noise,dat_tuningwidth,w)
%
% Inputs:
% ss = number of representations (1 or 2) that vary independently
% nTrials = number of trials in simulated data set
% e_noise = electrode noise
% c1_noise = channel noise for Representation 1
% c2_noise = channel noise for Representation 2
% w = weight matrix
% 
% Output
% d_n = matrix of synthetic data (with noise)
% posBin1 = position labels for Representation 1
% posBin2 = position labels for Representation 2 (only applies if ss = 2)

% set up location bins;
p.nBins = 8;
p.posBins = linspace(0,360-360/p.nBins,p.nBins);
for bin = 1:p.nBins
    p.posBinBounds(bin,:) = [p.posBins(bin)-22 p.posBins(bin)+22]; % specify end points of position bin to get full coverage of space
end

% specify basis set for generated predicted channel responses
nBins = 360;
nChans = 8;
em.sinPower = dat_tuningwidth;
em.x = linspace(0, 2*pi-2*pi/nBins, nBins);
em.cCenters = linspace(0, 2*pi-2*pi/nChans, nChans);
em.cCenters = rad2deg(em.cCenters);
pred = sin(0.5*em.x).^em.sinPower; % hypothetical channel responses
pred = wshift('1D',pred,5); % shift the initial basis function
basisSet = nan(nChans,nBins);
for c = 1:nChans;
    basisSet(c,:) = wshift('1D',pred,-em.cCenters(c)); % generate circularly shifted basis functions
end
basisSet = basisSet';

%--------------------------------------------------------------------------

% generate the position bin indices
cond.item1 = p.nBins;
cond.item2 = p.nBins;
tStructure = buildTrialStructure(cond,nTrials);
randInd = randperm(nTrials);
posBin1 = tStructure(1,randInd);
posBin2 = tStructure(2,randInd);


% specify stimulus location (as we do in our experiments)
for t = 1:nTrials
    tmpBinBounds = p.posBinBounds(posBin1(t),:);
    tmpPos = randsample(tmpBinBounds(1):tmpBinBounds(2),1);
    if tmpPos < 0
        tmpPos = tmpPos +360; % possible values = 0-359 degrees
    end
    pos1(1,t) = tmpPos;
    
    tmpBinBounds = p.posBinBounds(posBin2(t),:);
    tmpPos = randsample(tmpBinBounds(1):tmpBinBounds(2),1);
    if tmpPos < 0
        tmpPos = tmpPos +360; % possible values = 0-359 degrees
    end
    pos2(1,t) = tmpPos; 
end

% calculate predicted channel responses for each trial
c1 = nan(nTrials,nChans); c2 = nan(nTrials,nChans);
for t = 1:nTrials
    c1(t,:) = amp*basisSet(pos1(t)+1,:);
    c2(t,:) = amp*basisSet(pos2(t)+1,:);
    % note: +1 means values range from 1 to 360 rather than 0 to 359
end

if ss == 1
    c = c1;
    d = c*w; % use weight matrix to generate synthetic data
    noise = normrnd(0,e_noise,size(d));
    d_n = d + noise; % add electrode noise 
end

if ss == 2
    c = c1 + c2;
    d = c*w; % use weight matrix to generate synthetic data
    noise = normrnd(0,e_noise,size(d));
    d_n = d + noise; % add electrode noise
end 