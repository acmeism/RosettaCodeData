cumsd <- function(x) {
  n <- seq_along(x)
  sqrt(cumsum(x^2) / n - (cumsum(x) / n)^2)
}

set.seed(12345L)
x <- rnorm(10)

cumsd(x)
# [1] 0.0000000 0.3380816 0.8752973 1.1783628 1.2345538 1.3757142 1.2867220 1.2229056 1.1665168 1.1096814

# Compare to the naive implementation, i.e. compute sd on each sublist:
Vectorize(function(k) sd(x[1:k]) * sqrt((k - 1) / k))(seq_along(x))
# [1]        NA 0.3380816 0.8752973 1.1783628 1.2345538 1.3757142 1.2867220 1.2229056 1.1665168 1.1096814
# Note that the first is NA because sd is unbiased formula, hence there is a division by n-1, which is 0 for n=1.
