function startAcropolis(nCores)
% run this script when starting a job on acropolis (the UChicago Social Sciences
% cluster (it handles some perculiarities of the system). 
%
% set the parallel profile as local
pc = parcluster('local');
% set the temp file location to MATLABWORKDIR variable set in submit script
pc.JobStorageLocation = strcat(getenv('MATLABWORKDIR'));
% open a pool of nCores many worker processes
parpool(pc);
