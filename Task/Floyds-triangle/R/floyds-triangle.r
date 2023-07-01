Floyd <- function(n)
{
  #The first argument of the seq call is a well-known formula for triangle numbers.
  out <- t(sapply(seq_len(n), function(i) c(seq(to = 0.5 * (i * (i + 1)), by = 1, length.out = i), rep(NA, times = n - i))))
  dimnames(out) <- list(rep("", times = nrow(out)), rep("", times = ncol(out)))
  print(out, na.print = "")
}
Floyd(5)
Floyd(14)
