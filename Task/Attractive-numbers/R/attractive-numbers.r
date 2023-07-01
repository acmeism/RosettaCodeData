is_prime <- function(num) {
  if (num < 2) return(FALSE)
  if (num %% 2 == 0) return(num == 2)
  if (num %% 3 == 0) return(num == 3)

  d <- 5
  while (d*d <= num) {
    if (num %% d == 0) return(FALSE)
    d <- d + 2
    if (num %% d == 0) return(FALSE)
    d <- d + 4
  }
  TRUE
}

count_prime_factors <- function(num) {
  if (num == 1) return(0)
  if (is_prime(num)) return(1)
  count <- 0
  f <- 2
  while (TRUE) {
    if (num %% f == 0) {
      count <- count + 1
      num <- num / f
      if (num == 1) return(count)
      if (is_prime(num)) f <- num
    }
    else if (f >= 3) f <- f + 2
    else f <- 3
  }
}

max <- 120
cat("The attractive numbers up to and including",max,"are:\n")
count <- 0
for (i in 1:max) {
  n <- count_prime_factors(i);
  if (is_prime(n)) {
    cat(i," ", sep = "")
    count <- count + 1
  }
}
