library(gmp)

isgiuga <- function(n) {
  unique(factorize(n)) |> (function(v) all((n/v - 1) %% v == 0))()
}

count <- 0
n <- 4
while (count < 4) {
  if (isgiuga(n)) {
    cat(n, "")
    count <- count + 1
  }
  n <- n + 2
}
