function [basisSet] = makeBasis(sinPower);

% parameters to set
nChans = 8;
nBins = 8;

cCenters = linspace(0, 2*pi-2*pi/nChans, nChans);

% Specify basis set
em.sinPower = 7;
em.x = linspace(0, 2*pi-2*pi/nBins, nBins);
em.cCenters = linspace(0, 2*pi-2*pi/nChans, nChans);
em.cCenters = rad2deg(cCenters);
pred = sin(0.5*em.x).^sinPower; % hypothetical channel responses
pred = wshift('1D',pred,5); % shift the initial basis function
basisSet = nan(nChans,nBins);
for c = 1:nChans;
    basisSet(c,:) = wshift('1D',pred,-c); % generate circularly shifted basis functions
end