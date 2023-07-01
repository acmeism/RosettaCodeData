"%gcd%" <- function(u, v) {
  ifelse(u %% v != 0, v %gcd% (u%%v), v)
}
