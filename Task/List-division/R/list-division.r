ldivide <- function(v, n) {
  k <- length(v)
  if(n > k) stop("n cannot be greater than length of vector")
  int <- k %/% n
  rem <- k %% n
  lpart <- function(x) {
    if (x < rem) {
      v[x*(int+1)+seq_len(int+1)]
    } else {
      v[x*int+seq_len(int)+rem]
    }
  }
  lapply(seq_len(n)-1, lpart)
}

tests <- list(
  list(c(94, 94, 13, 77, 35, 10, 51, 27, 60), 6),
  list(c(19, 46, 43, 17, 94), 1),
  list(c(93, 88, 40, 88, 30, 68, 84, 25), 3),
  list(c(88, 94, 10, 27, 54, 14), 3),
  list(c(31, 19, 63, 57, 57, 74, 50, 14, 38), 4),
  list(c(72, 57, 89, 55, 36, 84, 10, 95, 99, 35), 7)
)

lapply(tests, function(l) do.call(ldivide, l))
