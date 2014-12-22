#library(Revobase);   setMKLthreads(4)
#parallel processing to be used in caret::train
library(foreach); library(doParallel)
if(exists("workers")) stopCluster(workers)
workers <- makeCluster(N.of.clusters);  registerDoParallel(workers)