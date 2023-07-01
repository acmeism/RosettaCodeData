divisors <- function (n) {
  Filter( function (m) 0 == n %% m, 1:(n/2) )
}

table = sapply(1:19999, function (n) sum(divisors(n)) )

for (n in 1:19999) {
  m = table[n]
  if ((m > n) && (m < 20000) && (n == table[m]))
    cat(n, " ", m, "\n")
}
