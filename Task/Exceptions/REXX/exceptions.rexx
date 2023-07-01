/*REXX program demonstrates handling an exception (negative #); catching is via a label.*/
          do j=9  by -5
          say  'the square root of '       j       " is "       sqrt(j)
          end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure;  parse arg x;  if x=0  then return 0;        d=digits();    h=d+6;   m.=9
      numeric digits;           numeric form;                 if x<0  then signal .sqrtNeg
      parse value format(x, 2, 1, , 0) 'E0'  with  g 'E' _ .;             g=g * .5'e'_ % 2
         do j=0  while h>9;      m.j=h;               h=h%2 + 1;          end  /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g) * .5;     end  /*k*/
      numeric digits d;          return  g/1
.sqrtNeg: say  'illegal SQRT argument (argument is negative):'   x;       exit 13
