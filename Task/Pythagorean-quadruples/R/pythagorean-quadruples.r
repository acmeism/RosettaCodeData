squares <- d <- seq_len(2200)^2
aAndb <- outer(squares, squares, '+')
aAndb <- aAndb[upper.tri(aAndb, diag = TRUE)]
sapply(squares, function(c) d <<- setdiff(d, aAndb + c))
print(sqrt(d))
