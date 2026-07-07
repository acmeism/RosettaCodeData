cuboid <- function(w, h, d) {
  s <- sqrt(3)/2
  plot(
    x = NA, xlab = NA, ylab = NA, axes = FALSE, asp = 1,
    xlim = c(0, (w+d)*s), ylim = c(0, h + (w+d)/2)
  )
  polygon(
    x = c(0, w*s, w*s, 0),
    y = c(w/2, 0, h, h + w/2),
    col = "red"
  )
  polygon(
    x = c(0, w*s, (w+d)*s, d*s),
    y = c(h + w/2, h, h + d/2, h + (w+d)/2),
    col = "blue"
  )
  polygon(
    x = c(w*s, (w+d)*s, (w+d)*s, w*s),
    y = c(0, d/2, h + d/2, h),
    col = "yellow"
  )
}

png("Cuboid-R.png", 800, 800)
cuboid(2, 3, 4)
dev.off()
