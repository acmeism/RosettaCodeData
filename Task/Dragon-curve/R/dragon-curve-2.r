# Generate and plot Dragon curve.
# translation of JavaScript v.#2: http://rosettacode.org/wiki/Dragon_curve#JavaScript
# 2/27/16 aev
# gpDragonCurve(ord, clr, fn, d, as, xsh, ysh)
# Where: ord - order (defines the number of line segments);
#   clr - color, fn - file name (.ext will be added), d - segment length,
#   as - axis scale, xsh - x-shift, ysh - y-shift
gpDragonCurve <- function(ord, clr, fn, d, as, xsh, ysh) {
  cat(" *** START:", date(), "order=",ord, "color=",clr, "\n");
  d=10; m=640; ms=as*m; n=bitwShiftL(1, ord);
  c=c1=c2=c2x=c2y=i1=0; x=y=x1=y1=0;
  if(fn=="") {fn="DCR"}
  pf=paste0(fn, ord, ".png");
  ttl=paste0("Dragon curve, ord=",ord);
  cat(" *** Plot file -", pf, "title:", ttl, "n=",n, "\n");
  plot(NA, xlim=c(-ms,ms), ylim=c(-ms,ms), xlab="", ylab="", main=ttl);
  for (i in 0:n) {
    segments(x1+xsh, y1+ysh, x+xsh, y+ysh, col=clr); x1=x; y1=y;
    c1=bitwAnd(c, 1); c2=bitwAnd(c, 2);
    c2x=d; if(c2>0) {c2x=(-1)*d}; c2y=(-1)*c2x;
    if(c1>0) {y=y+c2y} else {x=x+c2x}
    i1=i+1; ii=bitwAnd(i1, -i1); c=c+i1/ii;
  }
  dev.copy(png, filename=pf, width=m, height=m); # plot to png-file
  dev.off(); graphics.off();  # Cleaning
  cat(" *** END:",date(),"\n");
}
## Testing samples:
gpDragonCurve(7, "red", "", 20, 0.2, -30, -30)
##gpDragonCurve(11, "red", "", 10, 0.6, 100, 200)
gpDragonCurve(13, "navy", "", 10, 1, 300, -200)
##gpDragonCurve(15, "darkgreen", "", 10, 2, -450, -500)
gpDragonCurve(16, "darkgreen", "", 10, 3, -1050, -500)
