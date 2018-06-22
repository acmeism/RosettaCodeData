/*REXX program calculates the  AGM  (arithmetic─geometric mean)  of two (real) numbers. */
parse arg a b digs .                             /*obtain optional numbers from the C.L.*/
if digs=='' | digs==","  then digs=110           /*No DIGS specified?  Then use default.*/
numeric digits digs                              /*REXX will use lots of decimal digits.*/
if    a=='' |    a==","  then a=1                /*No A specified?  Then use the default*/
if    b=='' |    b==","  then b=1 / sqrt(2)      /* " B     "         "   "   "     "   */
call AGM a,b                                     /*invoke the  AGM  function.           */
say  '1st # ='      a                            /*display the   A   value.             */
say  '2nd # ='      b                            /*   "     "    B     "                */
say  '  AGM ='  agm(a, b)                        /*   "     "   AGM    "                */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
agm:  procedure: parse arg x,y;   if x=y  then return x      /*is this an equality case?*/
                                  if y=0  then return 0      /*is   Y  equal to zero ?  */
                                  if x=0  then return y / 2  /* "   X    "    "   "     */
      d=digits();  numeric digits d+5            /*add 5 more digs to ensure convergence*/
      tiny='1e-' || (digits() - 1)               /*construct a pretty tiny REXX number. */
      ox=x + 1
                        do #=1  while ox\=x & abs(ox)>tiny;  ox=x;          oy=y
                                                              x=(ox+oy)/2;   y=sqrt(ox*oy)
                        end   /*#*/
      numeric digits d;       return x / 1       /*restore digs, normalize X to new digs*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x; if x=0  then return 0; d=digits(); m.=9; numeric form; h=d+6
      numeric digits; parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;  g=g *.5'e'_ % 2
        do j=0  while h>9;      m.j=h;               h=h % 2  + 1;  end /*j*/
        do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g)*.5;  end /*k*/;    return g
