# Proper divisors. 12/10/16 aev
require(numbers);
V <- sapply(1:20000, Sigma, k = 0, proper = TRUE); ind <- which(V==max(V));
cat("  *** max number of divisors:", max(V), "\n"," *** for the following indices:",ind, "\n");
