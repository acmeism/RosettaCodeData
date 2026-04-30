test_points <- list(c(16, 3), c(12, 17), c(0, 6), c(-4, -6), c(16, 6), c(16, -7),
                    c(16, -3), c(17, -4), c(5, 19), c(19, -8), c(3, 16), c(12, 13),
                    c(3, -4), c(17, 5), c(-3, 15), c(-3, -9), c(0, 11), c(-9, -3),
                    c(-4, -2), c(12, 10))

x <- sapply(test_points, function(v) v[1])
y <- sapply(test_points, function(v) v[2])

indices <- chull(x, y)
cat(paste0("(", x[indices], ",", y[indices], ")"))
