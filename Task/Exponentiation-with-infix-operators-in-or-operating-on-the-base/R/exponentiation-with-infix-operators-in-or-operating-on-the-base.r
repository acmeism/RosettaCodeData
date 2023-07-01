expressions <- alist(-x ^ p, -(x) ^ p, (-x) ^ p, -(x ^ p))
x <- c(-5, -5, 5, 5)
p <- c(2, 3, 2, 3)
output <- data.frame(x,
                     p,
                     setNames(lapply(expressions, eval), sapply(expressions, deparse)),
                     check.names = FALSE)
print(output, row.names = FALSE)
