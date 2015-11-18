/*REXX program multiplies two integers by the Ethiopian/Russian peasant method*/
numeric digits 3000                    /*handle some ginormous integers.      */
parse arg a b _ .                      /*get two numbers from the command line*/
if \datatype(a,'W')  then call error  "1st argument isn't an integer."
if \datatype(b,'N')  then call error  "2nd argument isn't a valid number."
if b==''  |  _\==''  then call error  "two arguments weren't specified."
p=eMult(a,b)                           /*Ethiopian or Russian peasant method. */
w=max(length(a), length(b), length(p)) /*find the maximum width of 3 numbers. */
say  '      a='  right(a,w)            /*use right justification to display A.*/
say  '      b='  right(b,w)            /* "    "         "        "    "    B.*/
say  'product='  right(p,w)            /* "    "         "        "    "    P.*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
eMult: procedure;  parse arg x 1 ox,y  /*X and OX are set to the 1st argument.*/
$=0                                    /*product of the two integers (so far).*/
                    do  while x\==0           /*keep processing while X not 0.*/
                    if \isEven(x)  then $=$+y /*if odd, then add Y to product.*/
                    x= halve(x)               /*invoke the HALVE  function.   */
                    y=double(y)               /*   "    "  DOUBLE     "       */
                    end   /*while*/           /* [↑]  Ethiopian multiplication*/
return $*sign(ox)/1                           /*maintain correct sign for prod*/
/*──────────────────────────────────one─liner subroutines─────────────────────*/
double:  return  arg(1)  * 2           /*   *   is REXX  multiplication.      */
halve:   return  arg(1)  % 2           /*   %    "   "  integer division.     */
isEven:  return  arg(1) // 2 == 0      /*   //   "   "     "    remainder.    */
error:   say '***error!***' arg(1);    exit 13     /*display an error message.*/
