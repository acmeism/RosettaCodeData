/*REXX program to demonstrate  debugging  (TRACE)  information while executing a program*/
/*────────────────────────────────────────────── (below) the   I   is for information.  */
trace i
parse arg maxDiv .
if maxDiv=='' | maxDiv==","  then maxDiv= 1000   /*obtain optional argument from the CL.*/
say 'maximum random divisor is:'  maxDiv         /*display the max divisor being used.  */
total= 0

         do j=1  to 100
         total= total + j/random(maxDiv)
         end   /*j*/

say 'total=' total                               /*stick a fork in it,  we're all done. */
