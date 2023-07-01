mFact <- function(n, deg) prod(seq(from = n, to = 1, by = -deg))
cat("Pretty version:\n")
print(t(outer(setNames(1:10, 1:10), setNames(1:5, paste0("Degree ", 1:5, ":")), Vectorize(mFact))))
