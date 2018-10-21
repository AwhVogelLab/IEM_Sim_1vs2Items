function [tf] = fitEM(B1,B2,C1,tstl,posBins)

% Inputs:
% B1: training data
% B2: test data
% C1: predicted chan resp for training data
% tstl: position label for each row in the test data
% posBins: vector of positions

W = C1\B1; % estimate weights from trn data
C2 = (W'\B2')'; % estimate chan resp from test data (positions x chans)

% circularly shift the chan response for each position (i.e., for each row)
% so that chan offset = 0 is the middle (or the right of middle for even
% column numbers).
% note: you can verify this works by feeding in eye(8) as C2
n2shift = ceil(size(C2,2)/2);
for ii=1:size(C2,1)
    [~, shiftInd] = min(abs(posBins-tstl(ii)));
    C2(ii,:) = wshift('1D', C2(ii,:), shiftInd-n2shift-1);
end

tf = mean(C2,1); % average shifted channel responses