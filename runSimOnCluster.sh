##################################################
# Copy this file to the directory containing your matlab script
# "qsub runbatch.sh" will start the job
###################################################


#!/bin/bash
#PBS -N matlabpool
#Make sure this number matches what you have in your matlab code
#PBS -l nodes=1:ppn=12,mem=64gb
#PBS -V
#PBS -j oe

cd $PBS_O_WORKDIR

#Matlab can clobber it's temporary files if multiple instances are run at once
#Create a job specific temp directory to avoid this
mkdir -p ~/matlabtmp/$PBS_JOBID
export MATLABWORKDIR=~/matlabtmp/$PBS_JOBID

matlab -nodesktop -nosplash -r "ClusterWrapper(12,10000,1,0.8,1,13)" >> LogFile.log 
