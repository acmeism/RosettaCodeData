next_humble <- function(n) nextn(n, c(2,3,5,7))
humblenums <- function(n) Reduce(function(x, f) 1+f(x),
                                 rep(list(next_humble),n-1),
                                 init=2,
                                 accumulate=TRUE)-1

humblenums(50)

humble_digits <- function(n){
  digcounts <- rle(floor(log10(humblenums(n))))$lengths
  for(i in seq_along(digcounts[-1])){
    cat("There are", digcounts[i], "humble numbers with", i, "digit(s)", "\n")
  }
}

humble_digits(5000)
