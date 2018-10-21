function [blocks, nTrialsPerBlock, nTrialsPerBlock_C1, nTrialsPerBlock_C2] = makeBlockAssignment_CommonTrain(nBlocks,nBins,posBin,C1_Idx,C2_Idx)
% For experiments with two conditions. This function creates a block
% assignment such that the number of trials per position are equated across
% the two conditions. 
% For the common training procedure, you'll want to train on the complete
% blocks and test on the half blocks corresponding to each condition. 
%
% Joshua J. Foster, 1/31/2017
% JJF updated 3/9/2018
%
% Outputs:
% blocks = assignment of trials to block
% nTrialsPerBlock = # of trials per block
% nTrialsPerBlock_C1 = # of trials for condition 1
% nTrialsPerBlock_C2 = # of trials for condition 2
%
% Inputs:
% nBlocks = number of blocks to partition data into
% nBins = number of position bins
% posBin = position labels (should be an entry for every trial in the
% experiment). 
% C1_Idx = index of condition 1 trials (i.e. which trials belong to this condition)
% C2_idx = index of condition 2 trials

%% throw an error if the length of either condition indices don't match the
% number of trial per cond
if length(posBin) ~= length(C1_Idx);
    error('number of position labels do not match C1_Idx')
end
if length(posBin) ~= length(C2_Idx);
    error('number of position labels do not match C2_Idx') 
end
    
%% grab the position labels for each condition
C1_PosBin = posBin(C1_Idx);
C2_PosBin = posBin(C2_Idx); 

%% preallocate blocks vector
nTrials = length(C1_Idx); 
blocks = nan(nTrials,1);

%% determine the min number of trials per bin for each condition (first vs. second half).
binCnt = nan(2,nBins);
for bin = 1:nBins
    binCnt(1,bin) = sum(C1_PosBin == bin);
    binCnt(2,bin) = sum(C2_PosBin == bin);
end
minCnt = min(min(binCnt)); % # of trials for position bin with fewest trials
nPerBin = floor(minCnt/nBlocks); % max # of trials such that the # of trials for each bin can be equated within each block and across conditions

%% loop through conditions
for c = 1:2
    % grab the index of position bins
    if c == 1
        pBin = C1_PosBin;
    else
        pBin = C2_PosBin;
    end
    
    tmp_nTrials = length(pBin);
    shuffBlocks = nan(size(pBin));
    % shuffle trials
    shuffInd = randperm(tmp_nTrials)'; % create shuffle index
    shuffBin = pBin(shuffInd); % shuffle trial order
    
    % take the 1st nPerBin x nBlocks trials for each position bin.
    for bin = 1:nBins
        idx = find(shuffBin == bin); % get index for trials belonging to the current bin
        idx = idx(1:nPerBin*nBlocks); % drop excess trials
        x = repmat(1:nBlocks,nPerBin,1); shuffBlocks(idx) = x; % assign trials to blocks
    end
    
    % grab the index of position bins
    if c == 1
        C1_Blocks = nan(size(C1_PosBin));
        C1_Blocks(shuffInd) = shuffBlocks;
        % this is what gets replaced by the shuffle code...
    else
        C2_Blocks = nan(size(C2_PosBin));
        C2_Blocks(shuffInd) = shuffBlocks;
    end
end

%% regular blocks is just two conditions combined
blocks(C1_Idx) = C1_Blocks;
blocks(C2_Idx) = C2_Blocks;
nTrialsPerBlock = length(blocks(blocks == 1)); % # of trials per block
nTrialsPerBlock_C1 = length(blocks(blocks(C1_Idx)==1));
nTrialsPerBlock_C2 = length(blocks(blocks(C2_Idx)==1));
