digits <- function(n, nd) rev((n %/% (10^(1:nd - 1))) %% 10)

recombine <- function(v) Reduce(function(x, y) 10*x + y, v)

is_square <- function(n) sqrt(n) %% 1 == 0

is_subunit <- function(n, nd) {
  digs <- digits(n, nd)
  if (0 %in% digs || digs[1] == 1) return(list(result = FALSE))
  nsub <- recombine(digs - 1)
  res <- is_square(n) && is_square(nsub)
  list(result = res, n = n, rn = sqrt(n), nsub = nsub, rnsub = sqrt(nsub))
}

nd <- 2
count <- 0
n <- 36
while (count < 4) {
  test <- is_subunit(n, nd)
  if (test$result) {
    do.call(sprintf, c("%i = %i^2 and %i = %i^2", tail(test, -1))) |> cat("\n")
    count <- count + 1
  }
  n <- n + 100
  if (n > 10^(nd)) nd <- nd + 1
}
