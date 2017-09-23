# list of the vectors by inserting x in s at position 0...end.
linsert <- function(x,s) lapply(0:length(s), function(k) append(s,x,k))

# list of all permutations of 1:n
perm <- function(n){
    if (n == 1) list(1)
    else unlist(lapply(perm(n-1), function(s) linsert(n,s)),
                recursive = F)}

# permutations of a vector s
permutation <- function(s) unique(lapply(perm(length(s)), function(i) s[i]))
