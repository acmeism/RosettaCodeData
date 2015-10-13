/*REXX program finds the roots (which may be complex) of a quadratic function.*/
numeric digits 200                     /*use enough digits to handle extremes.*/
parse arg a b c .                      /*obtain the specified arguments: A B C*/
call quadratic  a,b,c                  /*solve quadratic function via the sub.*/
numeric digits  10                     /*reduce (output) digits for human eyes*/
r1=r1/1;  r2=r2/1; a=a/1; b=b/1; c=c/1 /*normalize numbers to the new digits. */
if r1j\=0  then r1=r1 || left('+',r1j>0)(r1j/1)"i"    /*handle complex number.*/
if r2j\=0  then r2=r2 || left('+',r2j>0)(r2j/1)"i"    /*   "      "       "   */
              say '    a ='   a        /*display the normalized value of   A. */
              say '    b ='   b        /*   "     "       "       "    "   B. */
              say '    c ='   c        /*   "     "       "       "    "   C. */
      say;    say 'root1 ='   r1       /*   "     "       "       "   1st root*/
              say 'root2 ='   r2       /*   "     "       "       "   2nd root*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
quadratic:  parse arg aa,bb,cc         /*obtain the specified three arguments.*/
   $=sqrt(bb**2-4*aa*cc);  L=length($) /*compute  SQRT (which may be complex).*/
   rp=1/(aa+aa);    c?=right($,1)=='i' /*compute reciprocal of 2*aa;  Complex?*/
   if c?  then do;  n=left($,L-1);  r1=-bb*rp;    r2=r1; r1j=n*rp; r2j=-r1j; end
          else do;  r1=(-bb+$)*rp;  r2=(-bb-$)*rp;       r1j=0;    r2j=0;    end
   return
/*────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x;   if x=0  then return 0;  d=digits();  i=;   m.=9
      numeric digits 9; numeric form; h=d+6;  if x<0  then  do; x=-x; i='i'; end
      parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;       g=g*.5'e'_%2
         do j=0  while h>9;      m.j=h;              h=h%2+1;         end  /*j*/
         do k=j+5  to 0  by -1;  numeric digits m.k; g=(g+x/g)*.5;    end  /*k*/
      numeric digits d;     return (g/1)i            /*make complex if  X < 0.*/
