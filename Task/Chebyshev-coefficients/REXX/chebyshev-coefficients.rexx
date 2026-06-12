/*REXX program calculates  N  Chebyshev coefficients for the range  0 ──► 1  (inclusive)*/
numeric digits length( pi() )  -  length(.)      /*DIGITS default is nine,  but use 71. */
parse arg a b N .                                /*obtain optional arguments from the CL*/
if a==''  |  a==","  then a=  0                  /*A  not specified?   Then use default.*/
if b==''  |  b==","  then b=  1                  /*B   "      "          "   "     "    */
if N==''  |  N==","  then N= 10                  /*N   "      "          "   "     "    */
fac= 2 / N;          pin= pi / N                 /*calculate a couple handy─dandy values*/
Dma= (b-a) / 2                                   /*calculate one─half of the difference.*/
Dpa= (b+a) / 2                                   /*    "        "      "  "     sum.    */
                     do k=0  for N;    f.k= cos( cos( pin * (k + .5) ) * Dma    +    Dpa)
                     end   /*k*/

     do j=0  for N;  z= pin * j                  /*The  LEFT('', ···) ────────►──────┐  */
     $= 0                                        /*  clause is used to align         │  */
                     do m=0  for N               /*  the non─negative values with    ↓  */
                     $= $ + f.m * cos(z*(m +.5)) /*  the     negative values.        │  */
                     end   /*m*/                 /*                     ┌─────◄──────┘  */
     cheby.j= fac * $                            /*                     ↓               */
     say right(j, length(N) +3)   " Chebyshev coefficient  is:"   left('', cheby.j >= 0),
         format(cheby.j, , 30)                   /*only show 30 decimal digits of coeff.*/
     end  /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
cos: procedure; parse arg x; numeric digits digits()+9; x=r2r(x); a=abs(x); numeric fuzz 5
     if a=pi   then return -1;  if a=pi*.5 | a=pi*2  then return 0;    pit= pi/3;  z= 1
     if a=pit  then return .5;  if a=pit*2           then return -.5;  q= x*x;     _= 1
       do k=2  by 2  until p=z;  p=z;  _= -_ * q/(k*k - k);  z= z+_;   end;       return z
/*──────────────────────────────────────────────────────────────────────────────────────*/
pi:  pi=3.1415926535897932384626433832795028841971693993751058209749445923078164;return pi
r2r: return  arg(1)  //  (pi() * 2)              /*normalize radians ───► a unit circle.*/
