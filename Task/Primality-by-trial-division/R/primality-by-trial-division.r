is.prime <- function(n) n == 2 || n > 2 && n %% 2 == 1 && (n < 9 || all(n %% seq(3, floor(sqrt(n)), 2) > 0))

which(sapply(1:100, is.prime))
# [1]  2  3  5  7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97
