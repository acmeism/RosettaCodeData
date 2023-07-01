# Abundant, deficient and perfect number classifications. 12/10/16 aev
require(numbers);
propdivcls <- function(n) {
  V <- sapply(1:n, Sigma, proper = TRUE);
  c1 <- c2 <- c3 <- 0;
  for(i in 1:n){
    if(V[i]<i){c1 = c1 +1} else if(V[i]==i){c2 = c2 +1} else{c3 = c3 +1}
  }
  cat(" *** Between 1 and ", n, ":\n");
  cat("   * ", c1, "deficient numbers\n");
  cat("   * ", c2, "perfect numbers\n");
  cat("   * ", c3, "abundant numbers\n");
}
propdivcls(20000);
