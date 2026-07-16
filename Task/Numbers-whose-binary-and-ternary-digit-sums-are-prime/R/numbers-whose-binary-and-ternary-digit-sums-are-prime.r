#Limit (200) is less than both 2^8 and 3^5
#Therefore, largest binary digit sum is 7 and largest ternary digit sum is 9
sp <- c(2, 3, 5, 7)

conjunct <- function(f, g) function(x) f(x) && g(x)

digsum <- function(n, nd, b) sum((n %/% (b^(1:nd - 1))) %% b)

prime_ds <- function(b, maxd) function(n) digsum(n, maxd, b) %in% sp

cat(Filter(conjunct(prime_ds(2, 8), prime_ds(3, 5)), 1:199))
