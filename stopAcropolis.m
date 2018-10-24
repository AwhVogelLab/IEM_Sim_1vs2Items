function stopAcropolis

delete(gcp)% close the workers and exi
poolobj = gcp('nocreate');
delete(poolobj);