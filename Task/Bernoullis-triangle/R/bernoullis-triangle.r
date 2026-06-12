bern_tri <- function(n, k) sum(choose(n, 0:k))

for(i in 0:14) cat(sapply(0:i, function(k) bern_tri(i, k)), "\n")
