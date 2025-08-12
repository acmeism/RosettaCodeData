library(gmp)

indices <- c(0,1,2*(1:30))
bnums <- sapply(indices, BernoulliQ)
names(bnums) <- paste0("B(", indices, ")")
print(bnums, initLine=FALSE)
