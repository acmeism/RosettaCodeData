## Plotting Sierpinski carpet fractal v.2. aev 4/2/17
## ord - order, fn - file name, ttl - plot title, clr - color
pSierpinskiC2 <- function(ord, fn="", ttl="", clr="brown") {
  m=640; abbr="SCR2"; dftt="Sierpinski carpet fractal v.2";
  cat(" *** START", abbr, date(), "\n");
  if(fn=="") {pf=paste0(abbr,"o", ord)} else {pf=paste0(fn, ".png")};
  if(ttl!="") {dftt=ttl}; ttl=paste0(dftt,", order ", ord);
  cat(" *** Plot file:", pf,".png", "title:", ttl, "\n");
  S = matrix(1,1,1);
  for (i in 1:ord) {
    Q = cbind(S,S,S); R = cbind(S,0*S,S); S = rbind(Q,R,Q);
  }
  plotmat(S, pf, clr, ttl);
  cat(" *** END", abbr, date(), "\n");
}
## Executing:
pSierpinskiC2(5);
