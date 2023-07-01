mFact <- function(n, deg) prod(seq(from = n, to = 1, by = -deg))
cat("Simple version:\n")
print(outer(1:10, 1:5, Vectorize(mFact)))
