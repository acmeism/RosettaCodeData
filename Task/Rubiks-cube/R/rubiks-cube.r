rubik <- function(col1, col2, col3) {
  s <- sqrt(3)/2
  par(lwd = 2)
  plot(
    x = NA, xlab = NA, ylab = NA, axes = FALSE, asp = 1,
    xlim = c(0, 2*s), ylim = c(0, 2)
  )
  polygon(x = s*c(0, 1, 1, 0), y = c(1/2, 0, 1, 3/2), col = col1)
  polygon(x = s*c(0, 1, 2, 1), y = c(3/2, 1, 3/2, 2), col = col2)
  polygon(x = s*c(1, 2, 2, 1), y = c(0, 1/2, 3/2, 1), col = col3)
  segments(
    x0 = s*c(1, 2, 4, 5, 0, 0, 3, 3, 1, 2, 4, 5)/3,
    y0 = c(2, 1, 1, 2, 5, 7, 2, 4, 8, 7, 7, 8)/6,
    x1 = s*c(1, 2, 4, 5, 3, 3, 6, 6, 4, 5, 1, 2)/3,
    y1 = c(8, 7, 7, 8, 2, 4, 5, 7, 11, 10, 10, 11)/6
  )
}

png("RubiksCube-R.png", 800, 800)
rubik("green", "white", "red")
dev.off()
