fact <- function(n) {
  if (n <= 1) 1
  else n * Recall(n - 1)
}
