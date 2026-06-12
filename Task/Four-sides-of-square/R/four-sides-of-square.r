square <- function(n){
 mat <- matrix(1, nrow = n, ncol = n)
 mat[2:(n-1), 2:(n-1)] <- 0
 mat
}

square(7)
square(8)

