/*REXX program multiplies two integers by the  Ethiopian  (or Russian peasant)  method. */
numeric digits 3000                              /*handle some gihugeic integers.       */
parse arg a b _ .                                /*get two numbers from the command line*/
if a==''              then call error  "1st argument wasn't specified."
if b==''              then call error  "2nd argument wasn't specified."
if _\==''             then call error  "too many arguments were specified: "  _
if \datatype(a, 'W')  then call error  "1st argument isn't an integer: "      a
if \datatype(b, 'N')  then call error  "2nd argument isn't a valid number: "  b
p=eMult(a, b)                                    /*Ethiopian or Russian peasant method. */
w=max(length(a), length(b), length(p))           /*find the maximum width of 3 numbers. */
say  '      a='  right(a, w)                     /*use right justification to display A.*/
say  '      b='  right(b, w)                     /* "    "         "        "    "    B.*/
say  'product='  right(p, w)                     /* "    "         "        "    "    P.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
eMult:   procedure;  parse arg x,y;  s=sign(x)   /*obtain the two arguments; sign for X.*/
         $=0                                     /*product of the two integers (so far).*/
                      do  while x\==0            /*keep processing while   X   not zero.*/
                      if \isEven(x)  then $=$+y  /*if odd,  then add   Y   to product.  */
                      x= halve(x)                /*invoke the  HALVE   function.        */
                      y=double(y)                /*   "    "   DOUBLE      "            */
                      end   /*while*/            /* [↑]  Ethiopian multiplication method*/
         return $*s/1                            /*maintain the correct sign for product*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
double:  return  arg(1)  * 2                     /*   *   is REXX's  multiplication.    */
halve:   return  arg(1)  % 2                     /*   %    "   "     integer division.  */
isEven:  return  arg(1) // 2 == 0                /*   //   "   "     division remainder.*/
error:   say '***error!***' arg(1);    exit 13   /*display an error message to terminal.*/
