/*REXX program calculates the  AGM  (arithmetic─geometric mean)  of two (real) numbers. */
parse arg a b digs .                             /*obtain optional numbers from the C.L.*/
if digs=='' | digs==","  then digs= 100          /*No DIGS specified?  Then use default.*/
numeric digits digs                              /*REXX will use lots of decimal digits.*/
if a==''    | a==","     then a=1                /*No  A  specified?   Then use default.*/
if b==''    | b==","     then b=1 / sqrt(2)      /*No  B  specified?     "   "     "    */
call AGM a,b                                     /*invoke AGM  &  don't show A,B,result.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
agm:  procedure: parse arg x,y;   if x=y  then return x       /*is it an equality case? */
                                  if y=0  then return 0       /*is value of   Y   zero? */
                                  if x=0  then return y / 2   /* "   "    "   X     "   */
      d= digits();   numeric digits d+5          /*add 5 more digs to ensure convergence*/
      tiny= '1e-'  ||  (digits() - 1)            /*construct a pretty tiny REXX number. */
      ox= x + 1
                       do #=1  while ox\=x & abs(ox)>tiny; ox= x;          oy= y
                                                            x= (ox+oy)/2;   y= sqrt(ox*oy)
                       end   /*#*/
      numeric digits d                           /*restore  numeric digits  to original.*/
                                                 /*this is the only output displayed ►─┐*/
      say 'digits='right(d, 7)",  iterations=" right(#, 3)          /* ◄───────────────┘*/
      return x/1                                 /*normalize    X    to the new digits. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x; if x=0  then return 0; d=digits(); m.=9; numeric form; h=d+6
      numeric digits; parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;  g=g *.5'e'_ % 2
        do j=0  while h>9;      m.j=h;               h=h % 2  + 1;  end /*j*/
        do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g)*.5;  end /*k*/;    return g
