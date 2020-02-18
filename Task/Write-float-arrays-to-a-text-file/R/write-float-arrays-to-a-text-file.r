writexy <- function(file, x, y, xprecision=3, yprecision=3) {
  fx <- formatC(x, digits=xprecision, format="g", flag="-")
  fy <- formatC(y, digits=yprecision, format="g", flag="-")
  dfr <- data.frame(fx, fy)
  write.table(dfr, file=file, sep="\t", row.names=F, col.names=F, quote=F)
}

x <- c(1, 2, 3, 1e11)
y <- sqrt(x)
writexy("test.txt", x, y, yp=5)
