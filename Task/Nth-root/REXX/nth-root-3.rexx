/*REXX program calculates the  Nth root  of  X,  with  DIGS  (decimal digits) accuracy. */
include Settings

say version; say 'Nth root'; say
parse arg x root digs .                          /*obtain optional arguments from the CL*/
if    x=='' |    x==","   then    x= 2           /*Not specified?  Then use the default.*/
if root=='' | root==","   then root= 2           /* "       "        "   "   "      "   */
if digs=='' | digs==","   then digs=65           /* "       "        "   "   "      "   */
numeric digits digs                              /*set the  decimal digits  to   DIGS.  */
say '       x = '    x                           /*echo the value of   X.               */
say '    root = '    root                        /*  "   "    "    "   ROOT.            */
say '  digits = '    digs                        /*  "   "    "    "   DIGS.            */
say '  answer = '    nroot(x, root)              /*show the value of   ANSWER.          */
exit                                             /*stick a fork in it,  we're all done. */
/*--------------------------------------------------------------------------------------*/
Nroot:
/* Nth root function = x^(1/n) */
procedure expose glob.
arg x,n
/* Fast values */
if x = 0 then
   return 0
if x = 1 then
   return 1
/* Formulas using faster methods */
if n = 2 then
   return Sqrt(x)
if n = 3 then
   return Cbrt(x)
if n = 4 then
   return Qtrt(x)
/* Calculate */
sx = Sign(x); x = Abs(x)
p1 = Digits(); p2 = p1+2
numeric digits 3
/* First guess low accuracy */
y = 1/Exp(Ln(x)/n)
numeric digits p2
/* Dynamic precision */
d = p2
do k = 1 while d > 4
   d.k = d; d = d%2+1
end
d.k = 4
/* Halley */
a = 1/n; b = n+1
do j = k to 1 by -1
   numeric digits d.j
   y = y*a*(b-x*y**n)
end
y = 1/y
if sx < 0 then
   y = -y
numeric digits p1
return y+0

include Numbers
include Functions
include Constants
include Abend
