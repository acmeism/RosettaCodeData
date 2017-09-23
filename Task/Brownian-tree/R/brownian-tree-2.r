# Generate and plot Brownian tree. Version #1.
# 7/27/16 aev
# gpBrownianTree1(m, n, clr, fn, ttl, dflg, psz)
# Where: m - defines matrix m x m; n - limit of the number of moves;
#   fn - file name (.ext will be added); ttl - plot title; dflg - 0-no dump,
#   1-dump: psz - picture size.
gpBrownianTree1 <- function(m, n, clr, fn, ttl, dflg=0, psz=600)
{
  cat(" *** START:", date(), "m=",m, "n=",n, "clr=",clr, "psz=", psz, "\n");
  M <- matrix(c(0), ncol=m, nrow=m, byrow=TRUE);
  # Seed in center
  x <- m%/%2; y <- m%/%2;
  M[x,y]=1;
  pf=paste0(fn, ".png");
  cat(" *** Plot file -", pf, "\n");
  # Main loops
  for (i in 1:n) {
    if(i>1) {
      x <- sample(1:m, 1, replace=FALSE)
      y <- sample(1:m, 1, replace=FALSE)}
    while(1) {
      ox = x; oy = y;
      x <- x + sample(-1:1, 1, replace=FALSE);
      y <- y + sample(-1:1, 1, replace=FALSE);
      if(x<=m && y<=m && x>0 && y>0 && M[x,y])
        {if(ox<=m && oy<=m && ox>0 && oy>0) {M[ox,oy]=1; break}}
      if(!(x<=m && y<=m && x>0 && y>0)) {break}
    }
  }
  plotmat(M, fn, clr, ttl, dflg, psz);
  cat(" *** END:",date(),"\n");
}
gpBrownianTree1(400,15000,"red", "BT1R", "Brownian Tree v.1", 1);
