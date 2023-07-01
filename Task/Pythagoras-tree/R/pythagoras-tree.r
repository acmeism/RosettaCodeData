## Recursive PT plotting
pythtree <- function(ax,ay,bx,by,d) {
  if(d<0) {return()}; clr="darkgreen";
  dx=bx-ax; dy=ay-by;
  x3=bx-dy; y3=by-dx;
  x4=ax-dy; y4=ay-dx;
  x5=x4+(dx-dy)/2; y5=y4-(dx+dy)/2;
  segments(ax,-ay,bx,-by, col=clr);
  segments(bx,-by,x3,-y3, col=clr);
  segments(x3,-y3,x4,-y4, col=clr);
  segments(x4,-y4,ax,-ay, col=clr);
  pythtree(x4,y4,x5,y5,d-1);
  pythtree(x5,y5,x3,y3,d-1);
}
## Plotting Pythagoras Tree. aev 3/27/17
## x1,y1,x2,y2 - starting position
## ord - order/depth, fn - file name, ttl - plot title.
pPythagorasT <- function(x1, y1,x2, y2, ord, fn="", ttl="") {
  cat(" *** START PYTHT:", date(), "\n");
  m=640; i=j=k=m1=m-2; x=y=d=dm=0;
  if(fn=="") {pf=paste0("PYTHTR", ord, ".png")} else {pf=paste0(fn, ".png")};
  if(ttl=="") {ttl=paste0("Pythagoras tree, order - ", ord)};
  cat(" *** Plot file -", pf, "title:", ttl, "\n");
  plot(NA, xlim=c(0,m), ylim=c(-m,0), xlab="", ylab="", main=ttl);
  pythtree(x1,y1, x2,y2, ord);
  dev.copy(png, filename=pf, width=m, height=m);
  dev.off(); graphics.off();
  cat(" *** END PYTHT:",date(),"\n");
}
## Executing:
pPythagorasT(275,500,375,500,9)
pPythagorasT(275,500,375,500,7)
