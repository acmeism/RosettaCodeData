## Recursive FT plotting
plotftree <- function(x, y, a, d, c) {
x2=y2=0; d2r=pi/180.0; a1 <- a*d2r; d1=0;
if(d<=0) {return()}
if(d>0)
  { d1=d*10.0;
    x2=x+cos(a1)*d1;
    y2=y+sin(a1)*d1;
    segments(x*c, y*c, x2*c, y2*c, col='darkgreen');
    plotftree(x2,y2,a-20,d-1,c);
    plotftree(x2,y2,a+20,d-1,c);
    #return(2);
  }
}
## Plotting Fractal Tree. aev 3/27/17
## ord - order/depth, c - scale, xsh - x-shift, fn - file name,
##  ttl - plot title.
pFractalTree <- function(ord, c=1, xsh=0, fn="", ttl="") {
  cat(" *** START FRT:", date(), "\n");
  m=640;
  if(fn=="") {pf=paste0("FRTR", ord, ".png")} else {pf=paste0(fn, ".png")};
  if(ttl=="") {ttl=paste0("Fractal tree, order - ", ord)};
  cat(" *** Plot file -", pf, "title:", ttl, "\n");
  ##plot(NA, xlim=c(0,m), ylim=c(-m,0), xlab="", ylab="", main=ttl);
  plot(NA, xlim=c(0,m), ylim=c(0,m), xlab="", ylab="", main=ttl);
  plotftree(m/2+xsh,100,90,ord,c);
  dev.copy(png, filename=pf, width=m, height=m);
  dev.off(); graphics.off();
  cat(" *** END FRT:",date(),"\n");
}
## Executing:
pFractalTree(9);
pFractalTree(12,0.6,210);
pFractalTree(15,0.35,600);
