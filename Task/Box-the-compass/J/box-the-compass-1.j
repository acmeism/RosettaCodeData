require'strings'
subs=: 'N,north,S,south,E,east,W,west,b, by ,'
dirs=: subs (toupper@{., }.)@rplc~L:1 0&(<;._2) 0 :0 -. ' ',LF
  N,NbE,N-NE,NEbN,NE,NEbE,E-NE,EbN,E,EbS,E-SE,SEbE,SE,SEbS,S-SE,SbE,
  S,SbW,S-SW,SWbS,SW,SWbW,W-SW,WbS,W,WbN,W-NW,NWbW,NW,NWbN,N-NW,NbW,
)
indice=: 32 | 0.5 <.@+ %&11.25
deg2pnt=: dirs {~ indice
