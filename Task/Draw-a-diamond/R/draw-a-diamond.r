cx <- 300
y1 <- 150
y2 <- 230
y3 <- 450

xstart <- c(cx-80, cx+80, cx+160, cx, cx-160, cx-160, cx-80, cx+80)
ystart <- c(y1, y1, y2, y3, y2, y2, y1, y1)
xend <- c(cx+80, cx+160, cx, cx-160, cx-80, cx+160, cx, cx)
yend <- c(y1, y2, y3, y2, y1, y2, y3, y3)

png("Diamond-R.png", 600, 600)
plot(NA, xlim = c(600, 0), ylim = c(600, 0),
     axes = FALSE, xlab = NA, ylab = NA, asp = 1)
segments(xstart, ystart, xend, yend, col = "blue", lwd = 3)
dev.off()
