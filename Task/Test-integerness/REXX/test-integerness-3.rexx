/*REXX program  tests  if a number  (possibly complex)  is  equivalent  to an integer.  */
numeric digits 3000                              /*be able to handle gihugic integers.  */
parse arg #s                                     /*obtain optional numbers list from CL.*/
if #s=''  then #s= '3.14   1.00000   33   999999999   99999999999   1e272   AA   0'    ,
                   '1.000-3i   1.000-3.3i   4j   2.00000000+0j   0j   333   -1-i'      ,
                   '1+i   .00i   j   0003-00.0j   1.2d1   2e55666   +0003-00.0j   +0j' ,
                   '-.3q+2   -0i   +03.0e+01+0.00e+20j   -030.0e-001+0.0e-020j'
                                                 /* [↑]  use these numbers for defaults.*/
  do j=1  for words(#s);    ox=word(#s, j)       /*obtain a number from the numbers list*/
  parse  upper  var  ox  x                       /*obtain an uppercase version of  OX.  */
  x=translate(x, 'EEI', "QDJ")                   /*translate exponent and imag indicator*/
  if right(x, 1)=='I'  then call tImag           /*has the  X  number an imaginary part?*/
  if isInt(x)  then say  right(ox, 55)  "     is an integer."      /*yuppers, it does.  */
               else say  right(ox, 55)  "  isn't an integer."      /*noppers, it doesn't*/
  end   /*j*/                                    /* [↑]  process each number in the list*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isInt:  procedure;  parse arg n                  /*obtain the number in question.       */
        if datatype(n, 'Whole')  then return 1   /*it's a simple integer (small).       */
        parse  var  n   m  'E'  p                /*separate base from the  10's  power. */
        if \datatype(p, 'Numb')  then return 0   /*Not an integer if  P  not an integer.*/
        return  p>0  |  m=0                      /*is   power>0   or   mantissa = zero? */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isSign: parse arg ? 2;   return ?=='+' | ?=="-"  /*a method to test for a leading sign. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
tImag:  x=left(x, length(x) -1)                  /*strip the trailing I or J from number*/
        if isInt(x)   then do                    /*is what's remaining an integer ?     */
                           if x\=0  then x=.     /*what's remaining isn't equal to zero.*/
                           return                /*return to invoker in either case.    */
                           end                   /* [↑]  handle simple imaginary case.  */
        if isSign(x)  then x=substr(x, 2)        /*X has a sign?  Strip the leading sign*/
        e=verify(x, .0123456789)                 /*find 1st char not a digit or a  dot. */
        if e==0       then do; x=.; return; end  /*Nothing?  Then it's not an integer.  */
        y=substr(x, e, 1)                        /*Y  is the suspect character.         */
        if isSign(y)  then do                    /*is suspect character a plus or minus?*/
                           z=substr(x, e+1)      /*obtain the imaginary part of  X.     */
                           x=  left(x, e-1)      /*   "    "    real      "   "  "      */
                           if isInt(z)  then if z=0  then return   /*imaginary part is 0*/
                           x=.                   /*the imaginary part isn't zero.       */
                           end                   /* [↑]  end of imaginary part of  X.   */
        if y\=='E'    then return                /*real part of X doesn't have an expon.*/
        p=substr(x, e+1)                         /*obtain power of real part of  X.     */
        _=  left(p, 1)                           /*obtain the possible sign of the power*/
        if isSign(_)  then p=substr(p, 2)        /*strip the sign from the exponent.    */
        s=verify(p, '-+', "M")                   /*is there an imaginary separator char?*/
        if s==0       then do; x=.; return; end  /*No sign?   Then isn't not an integer.*/
        z=substr(p, s+1)                         /*obtain the the imaginary part of  X. */
        x=  left(x, e+s)                         /*   "    "   "     real     "   "  "  */
        if isInt(z)   then if z\=0  then x=.     /*Not imaginary part=0? Not an integer.*/
        return                                   /*return to the invoker of this sub.   */
