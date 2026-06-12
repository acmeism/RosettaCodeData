# machine epsilon
mepsilon <- function(divisor) {
  guess <- 1.0
  while ((1.0 + guess) != 1.0) {
    guess <- guess / divisor
  }
  guess
}

# let's try from 2 to 1000
epsilons <- sapply(2:1000, FUN=mepsilon)
summary(epsilons)
#      Min.   1st Qu.    Median      Mean   3rd Qu.      Max.
# 2.439e-19 1.905e-18 5.939e-18 1.774e-17 2.238e-17 1.110e-16
