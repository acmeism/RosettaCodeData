co9 <- function(base) {
  x  <- 1:(base^2-1)
  x[(x %% (base-1)) == (x^2 %% (base-1))]
}
Map(co9,c(10,16,17))
