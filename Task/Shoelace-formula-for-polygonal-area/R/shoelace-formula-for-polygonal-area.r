shoelace <- function(...){
  coords_list <- list(...)
  xcoords <- sapply(coords_list, function(v) v[1])
  ycoords <- sapply(coords_list, function(v) v[2])
  lsum <- sum(xcoords*c(ycoords[-1], ycoords[1]))
  rsum <- sum(ycoords*c(xcoords[-1], xcoords[1]))
  abs(lsum-rsum)/2
}

shoelace(c(3,4), c(5,11), c(12,8), c(9,5), c(5,6))
