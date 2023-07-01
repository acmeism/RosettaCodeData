# Chaos Game  (Sierpinski triangle) 2/15/17 aev
# pChaosGameS3(size, lim, clr, fn, ttl)
# Where: size - defines matrix and picture size; lim - limit of the dots;
#   fn - file name (.ext will be added); ttl - plot title;
pChaosGameS3 <- function(size, lim, clr, fn, ttl)
{
  cat(" *** START:", date(), "size=",size, "lim=",lim, "clr=",clr, "\n");
  sz1=floor(size/2); sz2=floor(sz1*sqrt(3)); xf=yf=v=0;
  M <- matrix(c(0), ncol=size, nrow=size, byrow=TRUE);
  x <- sample(1:size, 1, replace=FALSE);
  y <- sample(1:sz2, 1, replace=FALSE);
  pf=paste0(fn, ".png");
  for (i in 1:lim) { v <- sample(0:3, 1, replace=FALSE);
    if(v==0) {x=x/2; y=y/2;}
    if(v==1) {x=sz1+(sz1-x)/2; y=sz2-(sz2-y)/2;}
    if(v==2) {x=size-(size-x)/2; y=y/2;}
    xf=floor(x); yf=floor(y); if(xf<1||xf>size||yf<1||yf>size) {next};
    M[xf,yf]=1;
  }
  plotmat(M, fn, clr, ttl, 0, size);
  cat(" *** END:",date(),"\n");
}
pChaosGameS3(600, 30000, "red", "SierpTriR1", "Sierpinski triangle")
