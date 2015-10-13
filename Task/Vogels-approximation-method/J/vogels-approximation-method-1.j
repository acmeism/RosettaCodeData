vam=:1 :0
:
  exceeding=. 0 <. -&(+/)
  D=. x,y exceeding x NB. x: demands
  S=. y,x exceeding y NB. y: sources
  C=. (m,.0),0        NB. m: costs
  B=. 1+>./,C         NB. bigger than biggest cost
  mincost=. <./@-.&0  NB. smallest non-zero cost
  penalty=. |@(B * 2 -/@{. /:~ -. 0:)"1 - mincost"1
  R=. C*0
  while. 0 < +/D,S do.
    pS=. penalty C
    pD=. penalty |:C
    if. pS >&(>./) pD do.
      row=. (i. >./) pS
      col=. (i. mincost) row { C
    else.
      col=. (i. >./) pD
      row=. (i. mincost) col {"1 C
    end.
    n=. (row{S) <. col{D
    S=. (n-~row{S) row} S
    D=. (n-~col{D) col} D
    C=. C * S *&*/ D
    R=. n (<row,col)} R
  end.
  _1 _1 }. R
)
