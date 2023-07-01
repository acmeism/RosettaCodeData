arithmeticMean <- function(a, b) { (a + b)/2 }
geometricMean <- function(a, b) { sqrt(a * b) }

arithmeticGeometricMean <- function(a, b) {
  rel_error <- abs(a - b) / pmax(a, b)
  if (all(rel_error < .Machine$double.eps, na.rm=TRUE)) {
    agm <- a
    return(data.frame(agm, rel_error));
  }
  Recall(arithmeticMean(a, b), geometricMean(a, b))
}

agm <- arithmeticGeometricMean(1, 1/sqrt(2))
print(format(agm, digits=16))
