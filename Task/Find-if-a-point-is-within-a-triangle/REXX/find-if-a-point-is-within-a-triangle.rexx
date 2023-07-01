/*REXX program determines if a   specified point   is within a   specified triangle.    */
parse arg p a b c .                              /*obtain optional arguments from the CL*/
if p=='' | p==","  then p= '(0,0)'               /*Not specified?  Then use the default.*/
if a=='' | a==","  then a= '(1.5,2.4)'           /* "      "         "   "   "     "    */
if b=='' | b==","  then b= '(5.1,-3.1)'          /* "      "         "   "   "     "    */
if c=='' | c==","  then c= '(-3.8,0.5)'          /* "      "         "   "   "     "    */
if  ?(p, a, b, c)  then @= ' is '                /*Is the point  inside the triangle ?  */
                   else @= " isn't "             /* "  "    "   outside  "      "       */
say 'point'   p    @    " within the triangle "      a     ','       b       ","       c
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
cert: parse arg z,W; if datatype(z,'N')  then return z; call serr z /*return coördinate.*/
serr: say W 'data point '  z  " isn't numeric or missing."; exit 13 /*tell error message*/
x: procedure; parse arg "(" x ','      ;  return cert(x,"X")  /*return the X coördinate.*/
y: procedure; parse arg       ',' y ")";  return cert(y,"Y")  /*   "    "  Y      "     */
$: parse arg aa,bb,cc;  return (x(aa)-x(cc)) *(y(bb)-y(cc)) - (x(bb)-x(cc)) *(y(aa)-y(cc))
?: #1=$(p,a,b); #2=$(p,b,c); #3=$(p,c,a); return (#1>=0&#2>=0&#3>=0) | (#1<=0&#2<=0&#3<=0)
