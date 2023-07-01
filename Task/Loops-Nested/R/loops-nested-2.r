m <- 10; n <- 10; mat <- matrix(sample(1:20L, m*n, replace=TRUE), nrow=m);
x<-which(mat==20,arr.ind=TRUE,useNames=FALSE)
x<-x[order(x[,1]),]
for(i in mat[1:x[1,1]-1,]) print(i)
for(i in mat[x[1,1],1:x[1,2]]) print(i)
