factors <- function(n) c(Filter(function(x) n %% x == 0, seq_len(n %/% 2)), n)
#Vectorize is an interesting alternative to the previous solution's lapply.
manyFactors <- function(vec) Vectorize(factors)(vec)
