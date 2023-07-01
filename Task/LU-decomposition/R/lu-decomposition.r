library(Matrix)
A <- matrix(c(1, 3, 5, 2, 4, 7, 1, 1, 0), 3, 3, byrow=T)
dim(A) <- c(3, 3)
expand(lu(A))
