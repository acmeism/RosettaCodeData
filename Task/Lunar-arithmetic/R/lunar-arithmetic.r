`%C+%` <- function(a, b) {
  ifelse(
    all(c(a, b) < 10),
    max(a, b),
    max(c(a, b) %% 10) + 10*`%C+%`(a %/% 10, b %/% 10)
  )
}

`%C*%` <- function(a, b) {
  ifelse(
    a < 10,
    ifelse(
      b < 10,
      min(a, b),
      min(a, b %% 10) + 10*`%C*%`(a, b %/% 10)
    ),
    `%C+%`(`%C*%`(a %% 10, b), 10*`%C*%`(a %/% 10, b))
  )
}

#Helper function that transforms operators into functions of a single vector
folding <- function(f) function(v) Reduce(f, v)

test_nums <- list(
  c(976, 348),
  c(23, 321),
  c(232, 35),
  c(123, 32192, 415, 8)
)

for (op in c(`%C+%`, `%C*%`)) cat(sapply(test_nums, folding(op)), "\n")

#Find first 20 lunar even numbers
#Lunar multiplication by 2 is equivalent to taking a digit-wise minimum with 2
#Ergo, all lunar even numbers contain 0, 1, and 2 only
#The first 20 unique lunar even numbers will be just 0 to 19 written in ternary
evens <- paste0(rep(0:2, each = 9), rep(0:2, each = 3), 0:2) |>
  head(20) |>
  as.numeric()

cat(evens)
#Test that this is correct (all these are equal to their own lunar double)
for (x in evens) stopifnot(x == 2 %C*% x)

#Find first 20 squares
lunarsq <- function(n) n %C*% n
cat(sapply(0:19, lunarsq))

#Find first 20 factorials
cat(Reduce(`%C*%`, 1:20, accumulate = TRUE))

#Find first number whose square is less than the previous
n <- 0
repeat {
  if (lunarsq(n) > lunarsq(n+1)) {
    cat(n+1)
    break
  }
  n <- n+1
}
