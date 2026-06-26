options(scipen = 99)

superfac <- function(n) prod(factorial(1:n))

hyperfac <- function(n) prod((1:n)^(1:n))

alt_fac <- function(n) sum(factorial(1:n) * (-1)^(n:1 - 1))

exp_fac <- function(n) Reduce(`^`, n:1, right = TRUE)

inv_fac <- function(n) {
  est <- ceiling(1+log(n)) #This is always at least equal to the inverse factorial of n
  out <- match(n, factorial(0:est))-1
  ifelse(is.na(out), "undefined", out)
}

c(superfac, hyperfac, alt_fac) |>
  sapply(function(f) sapply(0:9, f)) |>
  `colnames<-`(c("sf", "hf", "af")) |>
  `rownames<-`(0:9)

cat(sapply(0:4, exp_fac))
cat(sapply(c(1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800), inv_fac))
cat(inv_fac(119))
