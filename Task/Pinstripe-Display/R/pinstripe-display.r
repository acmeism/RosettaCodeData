disp_h <- 1080
disp_w <- 1920
gen_row <- function(n) rep(c(0, 1), each = n)
pinstripe <- matrix(data = 0, nrow = disp_w, ncol = disp_h)
q <- disp_h/4
for (i in 0:3) {
  pinstripe[, (1+q*i):(q*(i+1))] <- gen_row(4-i)
}
png(filename = "Pinstripe-R.png", width = disp_w, height = disp_h)
op <- par(mar = rep(0, 4), mai = rep(0, 4))
image(pinstripe, col = c("white", "black"), useRaster = TRUE, axes = FALSE)
par(op)
dev.off()
