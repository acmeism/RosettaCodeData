library(minpack.lm)

K <- 7800000000  # approximate world population
n0 <- 27  # starting at day 0 with 27 Chinese cases

x <- seq(from=0.0, 96.0, length=97)

# The model for logistic regression with a given r0
getPred <- function(par, xx) (n0 * exp(par$r * xx)) / (( 1 + n0 * (exp(par$r * xx) - 1) / K))

residFun <- function(p, observed, xx) observed - getPred(p, xx)

parStart <- list(r=0.5)

# Daily world totals of covid cases, all countries
observed <- c(
  27, 27, 27, 44, 44, 59, 59, 59, 59, 59, 59, 59, 59, 60, 60,
  61, 61, 66, 83, 219, 239, 392, 534, 631, 897, 1350, 2023,
  2820, 4587, 6067, 7823, 9826, 11946, 14554, 17372, 20615,
  24522, 28273, 31491, 34933, 37552, 40540, 43105, 45177,
  60328, 64543, 67103, 69265, 71332, 73327, 75191, 75723,
  76719, 77804, 78812, 79339, 80132, 80995, 82101, 83365,
  85203, 87024, 89068, 90664, 93077, 95316, 98172, 102133,
  105824, 109695, 114232, 118610, 125497, 133852, 143227,
  151367, 167418, 180096, 194836, 213150, 242364, 271106,
  305117, 338133, 377918, 416845, 468049, 527767, 591704,
  656866, 715353, 777796, 851308, 928436, 1000249, 1082054,
  1174652)

nls.out <- nls.lm(par=parStart, fn=residFun, observed=observed, xx = x)

cat("The r for the model is: ", coef(nls.out), "\n")

cat("Therefore, R0 is approximately: ", exp(12 * coef(nls.out)))
