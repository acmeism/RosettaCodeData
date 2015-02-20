/*REXX program calculates the value of  pi  using the  AGM  algorithm.  */
parse arg d .; if d=='' then d=500     /*D specified?  Then use default.*/
numeric digits d+5                     /*set the numeric digits to D+5. */
a=1;    n=1;   z=1/4;   g=sqrt(1/2)    /*calculate some initial values. */

        do j=1   until  a==old;  old=a /*keep calculating until no noise*/
        x=(a+g)*.5;     g=sqrt(a*g)    /*calculate the next set of terms*/
        z=z-n*(x-a)**2; n=n+n;   a=x   /*Z is used in final calculation.*/
        many=compare(a,old)            /*how many accurate digs computed*/
        if many==0   then many=d       /*adjust for the very last time. */
        say right('iteration' j,20) right(many,9) "digits"   /*show digs*/
        end   /*j*/                    /* [↑]  stop if  A  equals  OLD  */
say                                    /*display a blank line for a sep.*/
pi=a**2/z                              /*calculate the value of pi.     */
numeric digits d                       /*set the  numeric digits  to  D */
say pi/1                               /*display the computed value of π*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SQRT subroutine─────────────────────*/
sqrt: procedure;  parse arg x; if x=0  then return 0;  m.=9;  p=digits()
numeric digits 9;  numeric form;  m.0=p
parse value format(x,2,1,,0) 'E0' with g 'E' _ .;     g=g*.5'E'_%2;  m.1=p
      do j=2  while p>9;      m.j=p;   p=p%2+1;                  end /*j*/
      do k=j+5  to 0  by -1;  numeric digits m.k; g=.5*(g+x/g);  end /*k*/
                              numeric digits m.0;     return (g/1)
