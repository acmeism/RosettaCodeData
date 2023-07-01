/*REXX program uses a  subtractive generator, and creates a sequence of random numbers. */
s.0= 292929;                             s.1= 1;                       billion= 1e9
numeric digits 20
cI= 55;           do i=2    for cI-2;    s.i= mod( s(i-2)  -  s(i-1),  billion)
                  end   /*i*/
Cp= 34
                  do j=0    for cI;      r.j= s( mod( cP * (j+1), cI))
                  end   /*j*/
m= 219;   Cj= 24
                  do k=cI   to m;        _= k // cI
                  r._= mod( r( mod(k-cI, cI))  -  r( mod(k-cJ, cI) ),  billion)
                  end   /*m*/
t= 235
                  do n=m+1  to t;     _= n // cI
                  r._= mod( r( mod(n-cI, cI))  -  r( mod(n-cJ, cI) ),  billion)
                  say   right(r._, 40)
                  end   /*n*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
mod: procedure;   parse arg a,b;         return  ( (a // b)  +  b)  //  b
r:                parse arg #;           return  r.#
s:                parse arg #;           return  s.#
