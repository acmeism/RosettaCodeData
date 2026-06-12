disp_h <- 480
disp_w <- 640
mat <- matrix(0, nrow = disp_w, ncol = disp_h)
mat[sample(disp_w, 1), sample(disp_h, 1)] <- 1
png("DrawPixel2-R.png", disp_w, disp_h)
op <- par(mar = rep(0, 4), mai = rep(0, 4))
image(mat, col = c("white", "yellow"), useRaster = TRUE, axes = FALSE)
par(op)
dev.off()
