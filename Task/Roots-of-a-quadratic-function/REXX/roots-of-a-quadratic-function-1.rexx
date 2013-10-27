/*REXX program finds the roots (may be complex) of a quadratic function.*/
numeric digits 120                     /*use enough digits for extremes.*/
parse arg a b c .                      /*get specified arguments:  A B C*/
a=a/1;    b=b/1;    c=c/1              /*normalize the three numbers.   */
call quadratic  a b c                  /*solve the quadratic function.  */
numeric digits sqrt(digits())%1        /*reduce digits for human beans. */
r1=r1/1                                /*normalize to the new digits.   */
r2=r2/1                                /*    "      "  "   "    "       */
if r1j\=0 then r1=r1 || left('+',r1j>0)(r1j/1)"i"  /*handle complex num.*/
if r2j\=0 then r2=r2 || left('+',r2j>0)(r2j/1)"i"  /*   "      "      " */
say '    a =' a                        /*show value of  A.              */
say '    b =' b                        /*  "    "    "  B.              */
say '    c =' c                        /*  "    "    "  C.              */
say
say 'root1 =' r1                       /*show 1st root (may be complex).*/
say 'root2 =' r2                       /*  "  2nd   "    "   "    "     */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────QUADRATIC subroutine────────────────*/
quadratic:  parse arg aa bb cc .       /*obtain the specified arguments.*/
?=sqrt(bb**2-4*aa*cc)                  /*compute sqrt (might be complex)*/
aa2=1 / (aa+aa)                        /*compute reciprocal of  2*aa    */
if right(?,1)=='i'  then do            /*are the roots complex?         */
                         ?i=left(?,length(?)-1)
                         r1=-bb*aa2;    r2=r1;     r1j=?i*aa2; r2j=-?i*aa2
                         end
                    else do
                         r1=(-bb+?)*aa2;   r2=(-bb-?)*aa2;   r1j=0;  r2j=0
                         end
return
/*──────────────────────────────────SQRT subroutine─────────────────────*/
sqrt: procedure;  parse arg x,f;  if x=0 then return 0;  d=digits()
numeric digits 11; g=.sqrtG();     do j=0 while p>9;  m.j=p;  p=p%2+1; end
  do k=j+5 to 0 by -1; if m.k>11 then numeric digits m.k; g=.5*(g+x/g); end
  numeric digits d;return (g/1)i
.sqrtG: i=left('i',x<0);  numeric form;  m.=11;  p=d+d%4+2;  x=abs(x)
        parse value format(x,2,1,,0) 'E0' with g 'E' _ .; return g*.5'E'_%2
