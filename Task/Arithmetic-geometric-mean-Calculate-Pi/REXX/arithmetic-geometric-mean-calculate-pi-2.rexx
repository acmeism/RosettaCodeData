/*REXX program calculates value of pi using the AGM algorithm (running digits)*/
parse arg d .; if d=='' then d=500     /*D  not specified?  Then use default. */
numeric digits d+5                     /*set the numeric decimal digits to D+5*/
a=1;    n=1;   z=1/4;   g=sqrt(1/2)    /*calculate some initial values.       */

        do j=1   until  a==old;  old=a /*keep calculating until no more noise.*/
        x=(a+g)*.5;     g=sqrt(a*g)    /*calculate the next set of terms.     */
        z=z-n*(x-a)**2; n=n+n;   a=x   /*Z  is used in the final calculation. */
        many=compare(a,old)            /*how many accurate digits computed?   */
        if many==0   then many=d       /*adjust for the very last time.       */
        say right('iteration' j,20) right(many,9) "digits"      /*show digits.*/
        end   /*j*/                    /* [↑]  stop if  A  equals  OLD.       */
say                                    /*display a blank line for a separator.*/
pi=a**2/z                              /*display the computed value of  pi.   */
numeric digits d                       /*set the numeric decimal digits to  D.*/
say pi/1                               /*display the computed value of  pi.   */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
      numeric digits 9; numeric form; h=d+6;  if x<0  then  do; x=-x; i='i'; end
      parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
         do j=0  while h>9;      m.j=h;              h=h%2+1;         end  /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;    end  /*k*/
      numeric digits d;     return (g/1)i            /*make complex if  X < 0.*/
