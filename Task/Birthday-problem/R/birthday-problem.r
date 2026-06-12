birthdaytest <- function(npeople, nshared) {
  birthdays <- sample(365, npeople, replace = TRUE)
  runs <- rle(sort(birthdays))$lengths
  any(runs >= nshared)
}

birthdaysim <- function(nshared, nsims, n0) {
  npeople <- n0
  repeat {
    results <- replicate(nsims, birthdaytest(npeople, nshared))
    prob <- mean(results)
    if (prob > 0.5) {
      return(list("probability" = prob,
                  "shared" = nshared,
                  "minpeople" = npeople))
    } else npeople <- npeople+1
  }
}

fstring <- "%.4f chance of %.0f people sharing a birthday achieved at n = %.0f"
n0 <- 2
cat("Birthday simulation with 10000 trials for each number of people:\n")
for (i in 2:5) {
  bsim <- birthdaysim(i, 10000, n0)
  cat(do.call(sprintf, c(fstring, bsim)), "\n")
  n0 <- bsim$minpeople
}
