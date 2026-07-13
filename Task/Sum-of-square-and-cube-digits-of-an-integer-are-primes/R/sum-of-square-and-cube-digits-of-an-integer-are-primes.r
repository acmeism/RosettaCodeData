#The largest possible digit sum is 9x6 = 54
p <- c(2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 39, 41, 43, 47, 53)

conjunct <- function(f, g) function(x) f(x) && g(x)

digsum <- function(n, nd) sum((n %/% (10^(1:nd - 1))) %% 10)

prime_dsp <- function(pow, maxd) function(n) {
  dsp <- digsum(n^pow, maxd)
  ifelse(dsp == 1, FALSE, dsp %in% p || all(dsp %% p != 0))
}

Filter(conjunct(prime_dsp(2, 4), prime_dsp(3, 6)), 1:99) |> cat()
