# Generate and plot Brownian tree. Version #2.
# 7/27/16 aev
# gpBrownianTree2(m, n, clr, fn, ttl, dflg, psz)
# Where: m - defines matrix m x m; n - limit of the number of moves;
#   fn - file name (.ext will be added); ttl - plot title; dflg - 0-no dump,
#   1-dump; psz - picture size.
gpBrownianTree2 <- function(m, n, clr, fn, ttl, dflg=0, psz=600)
{
  cat(" *** START:", date(), "m=",m, "n=",n, "clr=",clr, "psz=", psz, "\n");
  M <- matrix(c(0), ncol=m, nrow=m, byrow=TRUE);
  # Random seed always
  x <- sample(1:m, 1, replace=FALSE); y <- sample(1:m, 1, replace=FALSE);
  M[x,y]=1;
  pf=paste0(fn,".png");
  cat(" *** Plot file -",pf,"Seed:",x,"/",y,"\n");
  # Main loops
  for (i in 1:n) {
    if(i>1) {
      x <- sample(1:m, 1, replace=FALSE)
      y <- sample(1:m, 1, replace=FALSE)}
    while(1) {
      dx <- sample(-1:1, 1, replace=FALSE);
      dy <- sample(-1:1, 1, replace=FALSE);
      nx=x+dx; ny=y+dy;
      if(!(nx<=m && ny<=m && nx>0 && ny>0)) {
        x <- sample(1:m, 1, replace=FALSE); y <- sample(1:m, 1, replace=FALSE)}
      else {if(M[nx,ny]) {M[x,y]=1; break}
        else{x=nx; y=ny;}}
    }
  }
  plotmat(M, fn, clr, ttl, dflg, psz);
  cat(" *** END:",date(),"\n");
}
gpBrownianTree2(400,5000,"brown", "BT2R", "Brownian Tree v.2", 1);

## Rename BT2R.dmp to BT2aR.dmp
plotv2("BT2aR", "orange", "Brownian Tree v.2a", 640)
