rotate <- function(v, n) {
  if (n == 0) v else c(tail(v, -n), head(v, n))
}

mobius <- function(n, b) {
  theta <- seq(0, 2*pi, length.out = n)
  r <- b+cos(theta)
  x <- r*cos(theta)
  y <- r*sin(theta)
  par(bg = "black")
  plot(x, y, axes = FALSE, xlab = NA, ylab = NA, type = "l", col = "red")
  segments(x, y, rotate(x, n%/%2), rotate(y, n%/%2), col = "red", lwd = 2)
}

png("MobiusStrip-R.png", 800, 600)
mobius(360, 0.15)
dev.off()
