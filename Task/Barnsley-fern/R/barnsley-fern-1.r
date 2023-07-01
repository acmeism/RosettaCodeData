## pBarnsleyFern(fn, n, clr, ttl, psz=600): Plot Barnsley fern fractal.
## Where: fn - file name; n - number of dots; clr - color; ttl - plot title;
## psz - picture size.
## 7/27/16 aev
pBarnsleyFern <- function(fn, n, clr, ttl, psz=600) {
  cat(" *** START:", date(), "n=", n, "clr=", clr, "psz=", psz, "\n");
  cat(" *** File name -", fn, "\n");
  pf = paste0(fn,".png"); # pf - plot file name
  A1 <- matrix(c(0,0,0,0.16,0.85,-0.04,0.04,0.85,0.2,0.23,-0.26,0.22,-0.15,0.26,0.28,0.24), ncol=4, nrow=4, byrow=TRUE);
  A2 <- matrix(c(0,0,0,1.6,0,1.6,0,0.44), ncol=2, nrow=4, byrow=TRUE);
  P <- c(.01,.85,.07,.07);
  # Creating matrices M1 and M2.
  M1=vector("list", 4); M2 = vector("list", 4);
  for (i in 1:4) {
    M1[[i]] <- matrix(c(A1[i,1:4]), nrow=2);
    M2[[i]] <- matrix(c(A2[i, 1:2]), nrow=2);
  }
  x <- numeric(n); y <- numeric(n);
  x[1] <- y[1] <- 0;
  for (i in 1:(n-1)) {
    k <- sample(1:4, prob=P, size=1);
    M <- as.matrix(M1[[k]]);
    z <- M%*%c(x[i],y[i]) + M2[[k]];
    x[i+1] <- z[1]; y[i+1] <- z[2];
  }
  plot(x, y, main=ttl, axes=FALSE, xlab="", ylab="", col=clr, cex=0.1);
  # Writing png-file
  dev.copy(png, filename=pf,width=psz,height=psz);
  # Cleaning
  dev.off(); graphics.off();
  cat(" *** END:",date(),"\n");
}
## Executing:
pBarnsleyFern("BarnsleyFernR", 100000, "dark green", "Barnsley Fern Fractal", psz=600)
