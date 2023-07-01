## Are x,y inside Sierpinski carpet (and where)? (1-yes, 0-no)
inSC <- function(x, y) {
  while(TRUE) {
    if(!x||!y) {return(1)}
    if(x%%3==1&&y%%3==1) {return(0)}
    x=x%/%3; y=y%/%3;
  } return(0);
}
## Plotting Sierpinski carpet fractal. aev 4/1/17
## ord - order, fn - file name, ttl - plot title, clr - color
pSierpinskiC <- function(ord, fn="", ttl="", clr="navy") {
  m=640; abbr="SCR"; dftt="Sierpinski carpet fractal";
  n=3^ord-1; M <- matrix(c(0), ncol=n, nrow=n, byrow=TRUE);
  cat(" *** START", abbr, date(), "\n");
  if(fn=="") {pf=paste0(abbr,"o", ord)} else {pf=paste0(fn, ".png")};
  if(ttl!="") {dftt=ttl}; ttl=paste0(dftt,", order ", ord);
  cat(" *** Plot file:", pf,".png", "title:", ttl, "\n");
  for(i in 0:n) {
    for(j in 0:n) {if(inSC(i,j)) {M[i,j]=1}
  }}
  plotmat(M, pf, clr, ttl);
  cat(" *** END", abbr, date(), "\n");
}
## Executing:
pSierpinskiC(5);
