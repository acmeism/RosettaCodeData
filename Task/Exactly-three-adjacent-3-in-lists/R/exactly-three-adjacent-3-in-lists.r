nconsecn <- function(n) function(v) identical(diff(which(v == n)), rep(1L, n-1))

test_vectors <- list(c(9, 3, 3, 3, 2, 1, 7, 8, 5),
                     c(5, 2, 9, 3, 3, 7, 8, 4, 1),
                     c(1, 4, 3, 6, 7, 3, 8, 3, 2),
                     c(1, 2, 3, 4, 5, 6, 7, 8, 9),
                     c(4, 6, 8, 7, 2, 3, 3, 3, 1))

sapply(test_vectors, nconsecn(3))
