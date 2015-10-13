/*REXX program calculates the  AGM (arithmetic─geometric mean) of two numbers.*/
parse arg a b digs .                   /*obtain optional numbers from the C.L.*/
if digs=='' | digs==','  then digs=100 /*No DIGS specified?  Then use default.*/
numeric digits digs                    /*REXX will use lots of decimal digits.*/
if a=='' | a==','  then a=1            /*No  A  specified?   Then use default.*/
if b=='' | b==','  then b=1/sqrt(2)    /*No  B  specified?     "   "     "    */
say '1st # ='      a                   /*display the   A   value.             */
say '2nd # ='      b                   /*   "     "    B     "                */
say '  AGM ='  agm(a, b)               /*   "     "   AGM    "                */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
agm:  procedure: parse arg x,y;   if x=y  then return x       /*equality case?*/
                                  if y=0  then return 0       /*is  Y  zero?  */
                                  if x=0  then return y/2     /* "  X    "    */
      d=digits();   numeric digits d+5 /*add 5 more digs to ensure convergence*/
      tiny='1e-' || (digits()-1);      /*construct a pretty tiny REXX number. */
      ox=x+1
             do  while ox\=x & abs(ox)>tiny;  ox=x;             oy=y
                                                 x=(ox+oy)/2;      y=sqrt(ox*oy)
             end   /*while ··· */

      numeric digits d                 /*restore  numeric digits  to original.*/
      return x/1                       /*normalize    X    to the new digits. */
/*────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
      numeric digits 9; numeric form; h=d+6;  if x<0  then  do; x=-x; i='i'; end
      parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
         do j=0  while h>9;      m.j=h;              h=h%2+1;         end  /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;    end  /*k*/
      numeric digits d;     return (g/1)i            /*make complex if  X < 0.*/
