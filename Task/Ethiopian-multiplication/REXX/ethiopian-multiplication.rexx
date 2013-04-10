/*REXX program multiplies 2 integers by Ethiopian/Russian peasant method*/
numeric digits 1000                    /*handle very large integers.    */
parse arg a b .                        /*handles zeroes & negative ints.*/
                                       /*A & B should be checked if ints*/
say 'a=' a
say 'b=' b
say 'product=' emult(a,b)
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────EMULT subroutine────────────────────*/
emult: procedure;  parse arg x 1 ox,y
prod=0
          do  while x\==0
          if \iseven(x)  then prod=prod+y
          x=halve(x)
          y=double(y)
          end
return prod*sign(ox)
/*──────────────────────────────────subroutines─────────────────────────*/
halve:  return arg(1)%2
double: return arg(1)*2
iseven: return arg(1)//2==0

          /*Note:  the above procedures don't modify (or define) any    */
          /*local variables, so there is no need to specify   PROCEDURE */

          /*REXX allows multiple definitions, only the 1st one is used. */
          /*Three different argument names (methodologies?) are shown.  */
halve:  procedure; parse arg ?;  return ?%2
double: procedure; parse arg x;  return x+x
iseven: procedure; parse arg _;  return _//2 == 0
