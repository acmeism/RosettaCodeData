/*REXX program shows and displays examples of multiple  RETURN  values  from a function.*/
numeric digits 70                                /*the default is:    NUMERIC DIGITS 9  */
parse arg a b .                                  /*obtain two numbers from command line.*/
if a=='' | a==","  then a= 82                    /*Not specified?  Then use the default.*/
if b=='' | b==","  then b= 20                    /* "      "         "   "   "     "    */
say '     a ='  a                                /*display the first number to the term.*/
say '     b ='  b                                /*   "     "  second   "    "  "    "  */
say copies('═', 50)                              /*display a separator line  "  "    "  */
z= arithmetics(a, b)                             /*call the function:   arithmetics     */
parse var z  abut sum diff rem div Idiv prod pow /*obtain the function's returned values*/
say '    || ='  abut                             /*display   abutment   to the terminal.*/
say '     + ='  sum                              /*   "        sum       "  "     "     */
say '     - ='  diff                             /*   "     difference   "  "     "     */
say '    // ='  rem                              /*   "     remainder    "  "     "     */
say '     / ='  div                              /*   "      quotient    "  "     "     */
say '     % ='  Idiv                             /*   "   int. quotient  "  "     "     */
say '     * ='  prod                             /*   "       product    "  "     "     */
say '    ** ='  pow                              /*   "        power     "  "     "     */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
arithmetics: procedure;  parse arg x,y;  return  x||y  x+y  x-y  x//y  x/y  x%y  x*y  x**y
