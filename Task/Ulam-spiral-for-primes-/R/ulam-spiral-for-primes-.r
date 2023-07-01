## Plotting Ulam spiral (for primes) 2/12/17 aev
## plotulamspirR(n, clr, fn, ttl, psz=600), where: n - initial size;
## clr - color; fn - file name; ttl - plot title; psz - picture size.
##
require(numbers);
plotulamspirR <- function(n, clr, fn, ttl, psz=600) {
  cat(" *** START:", date(), "n=",n, "clr=",clr, "psz=", psz, "\n");
  if (n%%2==0) {n=n+1}; n2=n*n;
  x=y=floor(n/2); xmx=ymx=cnt=1; dir="R";
  ttl= paste(c(ttl, n,"x",n," matrix."), sep="", collapse="");
  cat(" ***", ttl, "\n");
  M <- matrix(c(0), ncol=n, nrow=n, byrow=TRUE);
  for (i in 1:n2) {
    if(isPrime(i)) {M[x,y]=1};
    if(dir=="R") {if(xmx>0) {x=x+1;xmx=xmx-1}
                  else {dir="U";ymx=cnt;y=y-1;ymx=ymx-1}; next};
    if(dir=="U") {if(ymx>0) {y=y-1;ymx=ymx-1}
                  else {dir="L";cnt=cnt+1;xmx=cnt;x=x-1;xmx=xmx-1}; next};
    if(dir=="L") {if(xmx>0) {x=x-1;xmx=xmx-1}
                  else {dir="D";ymx=cnt;y=y+1;ymx=ymx-1}; next};
    if(dir=="D") {if(ymx>0) {y=y+1;ymx=ymx-1}
                  else {dir="R";cnt=cnt+1;xmx=cnt;x=x+1;xmx=xmx-1}; next};
  };
  plotmat(M, fn, clr, ttl,,psz);
  cat(" *** END:",date(),"\n");
}

## Executing:
plotulamspirR(100, "red", "UlamSpiralR1", "Ulam Spiral: ");
plotulamspirR(200, "red", "UlamSpiralR2", "Ulam Spiral: ",1240);
