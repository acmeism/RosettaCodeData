"%gcd%" <- function(v, t) {
  while ( (c <- v%%t) != 0 ) {
    v <- t
    t <- c
  }
  t
}
