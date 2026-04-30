disp_h <- 240
disp_w <- 320
mat <- matrix(0, nrow = disp_w, ncol = disp_h)
mat[100, 100] <- 1
png("DrawPixel-R.png", disp_w, disp_h)
op <- par(mar = rep(0, 4), mai = rep(0, 4))
image(mat, col = c("white", "red"), useRaster = TRUE, axes = FALSE)
par(op)
dev.off()
