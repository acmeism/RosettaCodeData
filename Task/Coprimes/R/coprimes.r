factors <- function(n) c(Filter(function(x) n %% x == 0, seq_len(n %/% 2)), n)
isCoprime <- function(p, q) all(intersect(factors(p), factors(q)) == 1)
output <- data.frame(p = c(21, 17, 36, 18, 60), q = c(15, 23, 12, 29, 15))
print(transform(output, "Coprime" = ifelse(mapply(isCoprime, p, q), "Yes", "No")))
