/*REXX program calculates the  Nth root  of  X,  with  DIGS  (decimal digits) accuracy. */
include Settings

say version; say 'Nth root'; say
parse arg x root digs .                          /*obtain optional arguments from the CL*/
if    x=='' |    x==","   then    x= 2           /*Not specified?  Then use the default.*/
if root=='' | root==","   then root= 2           /* "       "        "   "   "      "   */
if digs=='' | digs==","   then digs=65           /* "       "        "   "   "      "   */
numeric digits digs                              /*set the  decimal digits  to   DIGS.  */
say '       x = '    x                           /*echo the value of   X.               */
say '    root = '    root                        /*  "   "    "    "   ROOT.            */
say '  digits = '    digs                        /*  "   "    "    "   DIGS.            */
say '  answer = '    Nroot(x, root)              /*show the value of   ANSWER.          */
exit                                             /*stick a fork in it,  we're all done. */

include Numbers
include Functions
include Constants
include Abend
