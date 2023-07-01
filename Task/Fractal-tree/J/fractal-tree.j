require'gl2'
coinsert'jgl2'

L0=: 50           NB. initial length
A0=: 1r8p1        NB. initial angle: pi divided by 8
dL=: 0.9          NB. shrink factor for length
dA=: 0.75         NB. shrink factor for angle
N=: 14            NB. number of branches

L=: L0*dL^1+i.N  NB. lengths of line segments

NB. relative angles of successive line segments
A=: A0*(dA^i.N) +/\@:*("1) _1 ^ #:i.2 ^ N

NB. end points for each line segment
P=: 0 0+/\@,"2 +.*.inv (L0,0),"2 L,"0"1 A

wd {{)n
 pc P closeok;
 setp wh 480 640;
 cc C isidraw flush;
 pshow;
}}

gllines <.(10 + ,/"2 P-"1<./,/P)
