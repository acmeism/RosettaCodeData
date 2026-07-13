library(gmp)

isgiuga <- function(n) {
  facs <- factorize(n)
  if (!identical(facs, unique(facs))) return(FALSE)
  all((n/facs - 1) %% facs == 0)
}

count <- 0
n <- 6
while (count < 4) {
  if (isgiuga(n)) {
    cat(n, "")
    count <- count + 1
  }
  n <- n + 4
}
