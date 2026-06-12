E <- function(k, n) {
  s <- lapply(1:n, function(i) if (i <= k) 1 else 0)

  d <- n - k
  n <- max(k, d)
  k <- min(k, d)
  z <- d

  while (z > 0 || k > 1) {
    for (i in 1:k) {
      s[[i]] <- c(s[[i]], s[[length(s) - i + 1]])
    }
    s <- s[1:(length(s) - k)]
    z <- z - k
    d <- n - k
    n <- max(k, d)
    k <- min(k, d)
  }

  unlist(s)
}

# Test the function
cat(E(5, 13), sep = "")
# Output should be 1001010010100
