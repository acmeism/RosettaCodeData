/*REXX pgm to demonstrate handling an exception; catching is via a label*/
          do j=9  by -5  for 100
          say  'square root of'  j  "is"  sqrt(j)
          end   /*j*/
exit                                   /*stick a fork in it, we're done.*/

.sqrtNeg: say  'illegal SQRT argument (argument is negative):'  x
exit                                   /*exit (terminate) this program. */

/*─────────────────────────────────────SQRT subroutine──────────────────*/
sqrt: procedure; parse arg x; if x=0 then return 0; d=digits();numeric dig
      g=.sqrtGuess();       do j=0 while p>9;  m.j=p;  p=p%2+1;   end
      do k=j+5 to 0 by -1; if m.k>11 then numeric digits m.k; g=.5*(g+x/g)
      numeric digits d;  return g/1
.sqrtGuess: if x<0  then signal .sqrtNeg;  numeric form;   m.=11;   p=d+d%
      parse value format(x,2,1,,0) 'E0' with g 'E' _ .;   return g*.5'E'_%
