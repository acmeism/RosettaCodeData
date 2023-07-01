# Generate and plot Brownian tree. Version #3.
# 7/27/16 aev
# gpBrownianTree3(m, n, clr, fn, ttl, dflg, seed, psz):
# Where: m - defines matrix m x m; n - limit of the number of moves;
#   fn - file name (.ext will be added); ttl - plot title; dflg - 0-no dump,
#   1-dump; seed - 0-center, 1-random: psz - picture size.
gpBrownianTree3 <- function(m, n, clr, fn, ttl, dflg=0, seed=0, psz=600)
{
  cat(" *** START:", date(),"m=",m,"n=",n,"clr=",clr, "psz=",psz, "\n");
  M <- matrix(c(0), ncol=m, nrow=m, byrow=TRUE);
  # Random seed
  if(seed==1)
    {x <- sample(1:m, 1, replace=FALSE);y <- sample(1:m, 1, replace=FALSE)}
  # Seed in center
  else {x <- m%/%2; y <- m%/%2}
  M[x,y]=1;
  pf=paste0(fn,". png");
  cat(" *** Plot file -", pf, "Seed:",x,"/",y, "\n");
  # Main loops
  for (i in 1:n) {
    if(i>1) {
      x <- sample(1:m, 1, replace=FALSE)
      y <- sample(1:m, 1, replace=FALSE)}
    b <- 0;
    while(b==0) {
      dx <- sample(-1:1, 1, replace=FALSE)
      dy <- sample(-1:1, 1, replace=FALSE)
      if(!(x+dx<=m && y+dy<=m && x+dx>0 && y+dy>0))
        { x <- sample(1:m, 1, replace=FALSE)
          y <- sample(1:m, 1, replace=FALSE)
        }
      else{if(M[x+dx,y+dy]==1) {M[x,y]=1; b=1}
        else {x=x+dx; y=y+dy;} }
    }
  }
  plotmat(M, fn, clr, ttl, dflg, psz);
  cat(" *** END:", date(), "\n");
}
gpBrownianTree3(400,5000,"dark green", "BT3R", "Brownian Tree v.3", 1);
