/*──────────────────────────────────SQRT subroutine───────────────────────────*/
sqrt: procedure;  parse arg x;         if x=0  then return 0  /*handle 0 case.*/
if \datatype(x,'N')  then return '[n/a]'   /*Not Applicable ───if not numeric.*/
i=;  if x<0  then do; x=-x; i='i'; end /*handle complex numbers if  X  is < 0.*/
d=digits()                             /*get the current numeric precision.   */
m.=9                                   /*technique uses just enough digits.   */
h=d+6                                  /*use extra decimal digits for accuracy*/
numeric digits 9                       /*use "small" precision at first.      */
numeric form                           /*force scientific form of the number. */
if fuzz()\==0  then numeric fuzz 0     /*just in case invoker has a FUZZ  set.*/
parse value format(x,2,1,,0)  'E0'  with  g 'E' _ .  /*get the  X's  exponent.*/
     g=(g * .5) || 'e' || (_ % 2)      /*1st guesstimate for the square root. */
  /* g= g * .5     'e'    (_ % 2) */   /*a shorter & concise version of above.*/
                                       /*Note: to insure enough accuracy for  */
                                       /*  the result, the precision during   */
                                       /*  the SQRT calculations is increased */
                                       /*  by two extra decimal digits.       */
  do j=0  while  h>9;  m.j=h;  h=h%2+1 /*compute the sizes (digs) of precision*/
  end   /*j*/                          /* [↑]  precisions are stored in  M.   */
                                       /*now, we start to do the heavy lifting*/
  do k=j+5  to 0  by -1                /*compute the  √  with increasing digs.*/
  numeric digits m.k                   /*each iteration, increase the digits. */
  g=(g+x/g) * .5                       /*perform the nitty-gritty calculations*/
  end   /*k*/                          /* [↑]  * .5   is faster than   / 2    */
                                       /* [↓]  normalize √ ──► original digits*/
numeric digits d                       /* [↓]  make answer complex if  X < 0. */
return (g/1)i                          /*normalize, and add possible I suffix.*/
