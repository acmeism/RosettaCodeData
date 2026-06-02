expdigsum <- function(n) ifelse(n > 9, (n%%10)^(n%%10) + expdigsum(n%/%10), n^n)

cat(Filter(function(x) expdigsum(x) == x, 1:5000))
