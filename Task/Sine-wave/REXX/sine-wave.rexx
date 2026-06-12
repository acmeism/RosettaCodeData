/*REXX program  produces  a sine wave  (of a specified frequency)   for   N   seconds.  */
parse arg freq time .                            /*obtain optional arguments from the CL*/
if freq=='' | freq==","  then freq= 880          /*Not specified?  Then use the default.*/
if time=='' | time==","  then time=   5          /* "      "         "   "   "     "    */
call sound freq, time                            /*invoke a BIF to generate a sine wave.*/
exit 0                                           /*stick a fork in it,  we're all done. */
