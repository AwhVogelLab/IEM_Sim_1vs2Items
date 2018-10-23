function [SS1_TF SS2_TF sl_SS1 sl_SS2] = sim_1vs2Items(e_noise,SS1_amp,SS2_amp)
% calls function to generate synthetic data, runs encoding model on the
% synthetic data
%
% Inputs:
% e_noise = electrode noise (use 0 by default)
% SS1_amp = amplitude of underlying tuning for SS1 (Set Size 1)
% SS2_amp = amplitude of underlying tuning for SS2

% nTrials

% number of trials
nTrials = 576; % 560 trials per condition (this is a little less than the mean number of trials per cond in our actual sample)

% generate a weight matrix (30 electrodes x 8 channels)
nElectrodes = 30; % REVIEW
nChans = 8;
% w = normrnd(0,1,nChans,nElectrodes);
w = rand(nChans,nElectrodes); 

% simulate SS1 data
[SS1_dat,SS1_pos1,SS1_pos2] = simulateDat(1,nTrials,SS1_amp,e_noise,w);
% simulate SS2 data
[SS2_dat,SS2_pos1,SS2_pos2] = simulateDat(2,nTrials,SS2_amp,e_noise,w);

% concatenate data
dat = [SS1_dat; SS2_dat]; % complete data set
posBin = [SS1_pos1,SS2_pos1]'; % position labels for item 1
ss = [ones(1,nTrials),2*ones(1,nTrials)]; % set size labels
SS1_Idx = ss == 1;
SS2_Idx = ss == 2;

% details of IEM analysis
nBlocks = 3;
nIters = 50;
nBins = 8;
nChans = nBins;
tuningofBasis = 25;
basisSet = makeBasis(tuningofBasis); % specify the basis set that we'll use to fit the IEM

% preallocate matrices
tf_SS1 = nan(nIters,nBlocks,nChans);
tf_SS2 = nan(nIters,nBlocks,nChans);
sl_SS1 = nan(nIters,nBlocks);
sl_SS2 = nan(nIters,nBlocks);

for iter = 1:nIters
    
    [blocks nTrialsPerBlock, nTrialsPerBlock_C1, nTrialsPerBlock_C2] = makeBlockAssignment_CommonTrain(nBlocks,8,posBin,SS1_Idx,SS2_Idx);
    
    blockDat = nan(nBins*nBlocks,nElectrodes);
    blockDat_SS1 = nan(nBins*nBlocks,nElectrodes);
    blockDat_SS2 = nan(nBins*nBlocks,nElectrodes);
    labels = nan(nBins*nBlocks,1);
    blockNum = nan(nBins*nBlocks,1);
    c = nan(nBins*nBlocks,nChans);
    
    bCnt = 1;
    for i = 1:nBins
        for ii = 1:nBlocks
            blockDat(bCnt,:) = mean(dat(posBin == i & blocks == ii,:));
            blockDat_SS1(bCnt,:) = mean(dat(SS1_Idx' & posBin == i & blocks == ii,:));
            blockDat_SS2(bCnt,:) = mean(dat(SS2_Idx' & posBin == i & blocks == ii,:));
            labels(bCnt) = i;
            blockNum(bCnt) = ii;
            c(bCnt,:) = basisSet(i,:);
            bCnt = bCnt+1;
        end
    end
    
    for i = 1:nBlocks
        
        trnl = labels(blockNum~=i); % training labels
        tstl = labels(blockNum==i); % test labels
        
        C1 = c(blockNum~=i,:);     % predicted channel outputs for training data
        B1 = blockDat(blockNum~=i,:);    % training data
        B2_SS1 = blockDat_SS1(blockNum==i,:);    % SS1 test data
        B2_SS2 = blockDat_SS2(blockNum==i,:);    % SS2 test data
        
        % fit model with each test set
        posBins = 1:8;
        ctf_ss1 = fitEM(B1,B2_SS1,C1,tstl,posBins);
        ctf_ss2 = fitEM(B1,B2_SS2,C1,tstl,posBins);
        tf_SS1(iter,i,:) = ctf_ss1;
        tf_SS2(iter,i,:) = ctf_ss2;
        sl_SS1(iter,i) = ctfSlope(ctf_ss1);
        sl_SS2(iter,i) = ctfSlope(ctf_ss2);
        
    end
    
end

SS1_TF = squeeze(mean(mean(tf_SS1),2));
SS2_TF = squeeze(mean(mean(tf_SS2),2));
sl_SS1 = squeeze(mean(mean(sl_SS1)));
sl_SS2 = squeeze(mean(mean(sl_SS2)));