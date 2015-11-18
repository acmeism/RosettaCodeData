/*REXX pgm uses a subtractive generator, creates a sequence of random numbers.*/
numeric digits 20;   s.0=292929;    s.1=1;            billion=10**9
cI=55;    cJ=24;     cP=34;                           billion=1e9  /* [↑] same*/
                                    do i=2  to cI-1
                                    s.i=mod(s(i-2) - s(i-1), billion)
                                    end   /*i*/
          do j=0    to cI-1
          r.j=s(mod(cP*(j+1), cI))
          end   /*j*/
m=219
          do k=cI   to m;     x=k//cI
          r.x=mod(r(mod(k-cI, cI)) - r(mod(k-cJ, cI)), billion)
          end   /*m*/
t=235
          do n=m+1  to t;     y=n//cI
          r.y=mod(r(mod(n-cI, cI)) - r(mod(n-cJ, cI)), billion)
          say   right(r.y, 40)
          end   /*n*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
mod: procedure;      parse arg a,b;    return  ((a // b)  +  b)   //   b
r:   parse arg _;                      return  r._
s:   parse arg _;                      return  s._
