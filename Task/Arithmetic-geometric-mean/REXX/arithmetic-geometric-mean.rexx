/*REXX program calculates AGM (arithmetric-geometric mean) of 2 numbers.*/
parse arg a b digs .             /*obtain numbers from the command line.*/
if digs=='' then digs=100        /*no DIGS specified?  Then use default.*/
numeric digits digs              /*Now, REXX will use lots of digits.   */
if a=='' then a=1                /*no  A  specified?  Then use default. */
if b=='' then b=1/sqrt(2)        /*no  B  specified?    "   "     "     */
say '1st # =' a
say '2nd # =' b
say '  AGM =' agm(a,b)/1         /*divide by 1; goes from 105──►100 digs*/
say '  AGM =' agm(a,b)/1         /*dividing by 1 normalizes the REXX num*/
exit                                   /*stick a fork in it, we're done.*/
/*────────────────────────────AGM subroutine────────────────────────────*/
agm: procedure: parse arg x,y;   if x=y then return x   /*equality case.*/
if y=0 then return 0;    if x=0 then return .5*y        /*two "0" cases.*/
numeric digits digits()+5        /*add 5 more digs to ensure convergence*/
!='1e-' || (digits()-1);   _x=x+1

                do while _x\=x & abs(_x)>!;   _x=x;   _y=y;   x=(_x+_y)*.5
                y=sqrt(_x*_y)
                end   /*while*/
return x
/*────────────────────────────SQRT subroutine───────────────────────────*/
sqrt: procedure; parse arg x;if x=0 then return 0;d=digits();numeric digits 11
                 g=.sqrtGuess();  do j=0 while p>9;  m.j=p;  p=p%2+1;  end
                   do k=j+5 to 0 by -1;  if m.k>11 then numeric digits m.k
                 g=.5*(g+x/g);  end;  numeric digits d;  return g/1

.sqrtGuess:  numeric form scientific;    m.=11;    p=d+d%4+2
          parse value format(x,2,1,,0) 'E0' with g 'E' _ .;  return g*.5'E'_%2
