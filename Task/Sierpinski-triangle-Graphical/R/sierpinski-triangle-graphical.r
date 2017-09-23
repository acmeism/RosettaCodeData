## Plotting Sierpinski triangle. aev 4/1/17
## ord - order, fn - file name, ttl - plot title, clr - color
pSierpinskiT <- function(ord, fn="", ttl="", clr="navy") {
  m=640; abbr="STR"; dftt="Sierpinski triangle";
  n=2^ord; M <- matrix(c(0), ncol=n, nrow=n, byrow=TRUE);
  cat(" *** START", abbr, date(), "\n");
  if(fn=="") {pf=paste0(abbr,"o", ord)} else {pf=paste0(fn, ".png")};
  if(ttl!="") {dftt=ttl}; ttl=paste0(dftt,", order ", ord);
  cat(" *** Plot file:", pf,".png", "title:", ttl, "\n");
  for(y in 1:n) {
    for(x in 1:n) {
      if(bitwAnd(x, y)==0) {M[x,y]=1}
    ##if(bitwAnd(x, y)>0) {M[x,y]=1}   ## Try this for "reversed" ST
  }}
  plotmat(M, pf, clr, ttl);
  cat(" *** END", abbr, date(), "\n");
}
## Executing:
pSierpinskiT(6,,,"red");
pSierpinskiT(8);
