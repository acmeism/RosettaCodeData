/*REXX pgm normalizes an angle (in a scale), or converts angles from a scale to another.*/
numeric digits length( pi() )   -   length(.)    /*use the "length" of pi for precision.*/
parse arg x                                      /*obtain optional arguments from the CL*/
if x='' | x=","  then x= '-2 -1 0 1 2 6.2831853 16 57.2957795 359 399 6399 1000000'
w= 20;                                 w7= w+7   /*W:  # dec digits past the dec. point.*/
@deg = 'degrees';       @grd= "gradians";        @mil = 'mils';           @rad = "radians"
# = words(x)
call hdr @deg @grd @mil @rad
      do j=1  for #;            y= word(x,j)
      say shw(y)        fmt(d2d(y))              fmt(d2g(y))    fmt(d2m(y))    fmt(d2r(y))
      end   /*j*/

call hdr @grd @deg @mil @rad
      do j=1  for #;            y= word(x,j)
      say shw(y)        fmt(g2g(y))              fmt(g2d(y))    fmt(g2m(y))    fmt(g2r(y))
      end   /*j*/

call hdr @mil @deg @grd @rad
      do j=1  for #;            y= word(x,j)
      say shw(y)        fmt(m2m(y))              fmt(m2d(y))    fmt(m2g(y))    fmt(m2r(y))
      end   /*j*/

call hdr @rad @deg @grd @mil
      do j=1  for #;            y= word(x,j)
      say shw(y)        fmt(r2r(y))              fmt(r2d(y))    fmt(r2g(y))    fmt(r2m(y))
      end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
fmt: _= format(arg(1), 6,w);  L= length(_);  return left(format(_/1, 6),L)   /*align a #*/
shw: _= format(arg(1),12,9);  L= length(_);  return left(format(_/1,12),L)   /*  "   " "*/
pi:  pi= 3.1415926535897932384626433832795028841971693993751058209749445923078;  return pi
d2g: return d2d(arg(1)) *   10  /    9           /*convert degrees   ───► gradians.     */
d2m: return d2d(arg(1)) *  160  /    9           /*convert degrees   ───► mils.         */
d2r: return d2d(arg(1)) * pi()  /  180           /*convert degrees   ───► radians.      */
g2d: return g2g(arg(1)) *    0.9                 /*convert gradians  ───► degrees.      */
g2m: return g2g(arg(1)) *   16                   /*convert gradians  ───► mils.         */
g2r: return g2g(arg(1)) * pi()  *    0.005       /*convert gradians  ───► radians.      */
m2d: return m2m(arg(1)) *    9  *    0.00625     /*convert mils      ───► degrees.      */
m2g: return m2m(arg(1)) /   16                   /*convert mils      ───► gradians.     */
m2r: return m2m(arg(1)) * pi()  / 3200           /*convert mils      ───► radians.      */
r2d: return r2r(arg(1)) *  180  / pi()           /*convert radians   ───► degrees.      */
r2g: return r2r(arg(1)) *  200  / pi()           /*convert radians   ───► gradians.     */
r2m: return r2r(arg(1)) * 3200  / pi()           /*convert radians   ───► mils.         */
d2d: return     arg(1) //  360                   /*normalize degrees ───► a unit circle.*/
g2g: return     arg(1) //  400                   /*normalize gradians───► a unit circle.*/
m2m: return     arg(1) // 6400                   /*normalize mils    ───► a unit circle.*/
r2r: return     arg(1) // (pi() * 2)             /*normalize radians ───► a unit circle.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
hdr: parse arg #o #a #b #c .;         _= '═';              say   /* [↓]  the header line*/
                                @n  = 'normalized'
     say center(#o,23  )  center(@n #o,w7) center(#a,w7  ) center(#b,w7  ) center(#c,w7  )
     say center('',23,_)  center('',w7, _) center('',w7,_) center('',w7,_) center('',w7,_)
     return                                                      /* '↑'  seperator line.*/
