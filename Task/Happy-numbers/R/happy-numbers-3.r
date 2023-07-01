#Find happy numbers between 1 and 50
which(apply(rbind(1:50), 2, is.happy))
