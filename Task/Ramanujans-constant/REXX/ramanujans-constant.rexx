/*REXX pgm displays Ramanujan's constant to at least  100  decimal digits of precision. */
d= min( length(pi()), length(e()) )  - length(.) /*calculate max #decimal digs supported*/
parse arg digs sDigs . 1 . . $                   /*obtain optional arguments from the CL*/
if  digs=='' |  digs==","  then  digs= d         /*Not specified?  Then use the default.*/
if sDigs=='' | sDigs==","  then sDigs= d % 2     /* "      "         "   "   "      "   */
if     $=''  |     $=","   then $= 19 43 67 163  /* "      "         "   "   "      "   */
 digs= min( digs, d)                             /*the minimum decimal digs for calc.   */
sDigs= min(sDigs, d)                             /* "     "       "      "      display.*/
numeric digits digs                              /*inform REXX how many dec digs to use.*/
say "The value of Ramanujan's constant calculated with " d ' decimal digits of precision.'
say "shown with "    sDigs    ' decimal digits past the decimal point:'
say
       do  j=1  for words($);   #= word($, j)    /*process each of the Heegner numbers. */
       say 'When using the Heegner number: '  #  /*display which Heegner # is being used*/
       z= exp(pi * sqrt(#) )                     /*perform some heavy lifting here.     */
       say format(z, 25, sDigs);           say   /*display a limited amount of dec digs.*/
       end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
pi:    pi= 3.1415926535897932384626433832795028841971693993751058209749445923078164062862,
           || 089986280348253421170679821480865132823066470938446095505822317253594081284,
           || 8111745028410270193852110555964462294895493038196;     return pi
/*──────────────────────────────────────────────────────────────────────────────────────*/
e:     e = 2.7182818284590452353602874713526624977572470936999595749669676277240766303535,
           || 475945713821785251664274274663919320030599218174135966290435729003342952605,
           || 9563073813232862794349076323382988075319525101901;     return  e
/*──────────────────────────────────────────────────────────────────────────────────────*/
exp:   procedure; parse arg x;  ix= x%1;  if abs(x-ix)>.5  then ix= ix + sign(x);  x= x-ix
       z=1;  _=1;   w=z;     do j=1; _= _*x/j;  z=(z+_)/1; if z==w  then leave;  w=z;  end
       if z\==0  then z= z * e() ** ix;                                         return z/1
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt:  procedure; parse arg x;  if x=0  then return 0;  d=digits();  h=d+6; numeric digits
       numeric form; m.=9; parse value format(x,2,1,,0) 'E0' with g 'E' _ .;  g=g*.5'e'_%2
         do j=0  while h>9;      m.j=h;               h=h % 2  +  1;   end /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g) * .5;  end /*k*/; return g
