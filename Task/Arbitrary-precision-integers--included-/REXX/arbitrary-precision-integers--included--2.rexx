/*REXX program calculates and demonstrates  arbitrary precision numbers (using powers). */
numeric digits 5                                 /*just use enough digits for 1st time. */

                  #=5** (4** (3** 2) )           /*calculate multiple exponentiations.  */

parse var  #  'E'  pow  .                        /*POW   might be null,  so   N  is OK. */

if pow\==''  then do                             /*general case:   POW  might be < zero.*/
                  numeric digits  abs(pow) + 9   /*recalculate with more decimal digits.*/
                  #=5** (4** (3** 2) )           /*calculate multiple exponentiations.  */
                  end                            /* [↑]  calculation is the real McCoy. */

true=62060698786608744707...92256259918212890625 /*what answer is supposed to look like.*/
rexx= left(#, 20)'...'right(#, 20)               /*the left and right 20 decimal digits.*/

say  '  true:'    true                           /*show what the  "true"  answer is.    */
say  '  REXX:'    rexx                           /*  "    "   "    REXX      "    "     */
say  'digits:'    length(#)                      /*  "    "   "   length  of answer is. */
say
if true == rexx   then say 'passed!'             /*either it passed,  ···               */
                  else say 'failed!'             /*    or it didn't.                    */
                                                 /*stick a fork in it,  we're all done. */
