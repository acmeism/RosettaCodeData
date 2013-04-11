runsum <- function(v) {
  rs <- c()
  for(i in 1:length(v)) {
    rs <- c(rs, sum(v[1:i]))
  }
  rs
}

grade <- function(v) {
  g <- vector("numeric", length(v))
  for(i in 1:length(v)) {
    g[v[i]] <- i-1
  }
  g
}

makespiral <- function(spirald) {
  series <- vector("numeric", spirald^2)
  series[] <- 1
  l <- spirald-1; p <- spirald+1
  s <- 1
  while(l > 0) {
    series[p:(p+l-1)] <- series[p:(p+l-1)] * spirald*s
    series[(p+l):(p+l*2-1)] <- -s*series[(p+l):(p+l*2-1)]
    p <- p + l*2
    l <- l - 1; s <- -s
  }
  matrix(grade(runsum(series)), spirald, spirald, byrow=TRUE)

}

print(makespiral(5))
