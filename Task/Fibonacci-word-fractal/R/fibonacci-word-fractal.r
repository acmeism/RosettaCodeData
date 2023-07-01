## Fibonacci word/fractal  2/20/17 aev
## Create Fibonacci word order n
fibow <- function(n) {
  t2="0"; t1="01"; t="";
  if(n<2) {n=2}
  for (i in 2:n) {t=paste0(t1,t2); t2=t1; t1=t}
  return(t)
}
## Plot Fibonacci word/fractal:
## n - word order, w - width, h - height, d - segment size, clr - color.
pfibofractal <- function(n, w, h, d, clr) {
  dx=d; x=y=x2=y2=tx=dy=nr=0;
  if(n<2) {n=2}
  fw=fibow(n); nf=nchar(fw);
  pf = paste0("FiboFractR", n, ".png");
  ttl=paste0("Fibonacci word/fractal, n=",n);
  cat(ttl,"nf=", nf, "pf=", pf,"\n");
  plot(NA, xlim=c(0,w), ylim=c(-h,0), xlab="", ylab="", main=ttl)
  for (i in 1:nf) {
    fwi=substr(fw, i, i);
    x2=x+dx; y2=y+dy;
    segments(x, y, x2, y2, col=clr); x=x2; y=y2;
    if(fwi=="0") {tx=dx; nr=i%%2;
      if(nr==0) {dx=-dy;dy=tx} else {dx=dy;dy=-tx}}
  }
  dev.copy(png, filename=pf, width=w, height=h); # plot to png-file
  dev.off(); graphics.off();  # Cleaning
}

## Executing:
pfibofractal(23, 1000, 1000, 1, "navy")
pfibofractal(25, 2300, 1000, 1, "red")
