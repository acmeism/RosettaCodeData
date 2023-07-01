price_fraction <- function(x)
{
  stopifnot(all(x >= 0 & x <= 1))
  breaks <- seq(0.06, 1.01, 0.05)
  values <- c(.1, .18, .26, .32, .38, .44, .5, .54, .58, .62, .66, .7, .74, .78, .82, .86, .9, .94, .98, 1)
  indices <- sapply(x, function(x) which(x < breaks)[1])
  values[indices]
}

#Example usage:
price_fraction(c(0, .01, 0.06, 0.25, 1))                # 0.10 0.10 0.18 0.38 1.00
