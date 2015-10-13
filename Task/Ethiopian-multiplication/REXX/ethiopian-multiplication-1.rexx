/*REXX program multiplies two integers by the Ethiopian/Russian peasant method*/
numeric digits 3000                    /*handle some gihugeic integers.       */
parse arg a b .                        /*get two numbers from the command line*/
say 'a=' a
say 'b=' b
say 'product=' eMult(a,b)
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
eMult: procedure;  parse arg x 1 ox,y  /*X and OX are set to the 1st argument.*/
$=0                                    /*product of the two integers (so far).*/
                   do  while x\==0            /*keep processing while X not 0.*/
                   if \isEven(x)  then $=$+y  /*if odd, then add Y to product.*/
                   x= halve(x)                /*invoke the HALVE  function.   */
                   y=double(y)                /*   "    "  DOUBLE     "       */
                   end   /*while*/            /* [↑]  Ethiopian multiplication*/
return $*sign(ox)                             /*maintain correct sign for prod*/
/*──────────────────────────────────one─liner subroutines─────────────────────*/
double:  return  arg(1)  * 2           /*   *   is REXX  multiplication.      */
halve:   return  arg(1)  % 2           /*   %    "   "  integer division.     */
isEven:  return  arg(1) // 2 == 0      /*   //   "   "     "    remainder.    */
