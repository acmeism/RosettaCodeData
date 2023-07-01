entropy <- function(str) {
  vec   <- strsplit(str, "")[[1]]
  N     <- length(vec)
  p_xi  <- table(vec) / N

  -sum(p_xi * log(p_xi, 2))
}
