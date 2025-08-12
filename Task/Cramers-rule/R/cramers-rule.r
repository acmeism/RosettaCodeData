eqns <- cbind("w"=c(2,3,1,5),
              "x"=c(-1,2,3,-2),
              "y"=c(5,2,3,-3),
              "z"=c(1,-6,-1,3),
              "d"=c(-3,-32,-47,49))

coeffs <- subset(eqns, select=-d)
indices <- matrix(data=1:4, nrow=4, ncol=4, byrow=TRUE)
for(i in 1:4) indices[i,i] <- 5
solver <- function(n) det(eqns[,indices[n,]])/det(coeffs)

setNames(sapply(1:4, solver), c("w","x","y","z"))
