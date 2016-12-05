/*REXX program  swaps the letter case of a string:  lower ──► upper  &  upper ──► lower.*/
abc = "abcdefghijklmnopqrstuvwxyz"               /*define all the  lowercase  letters.  */
abcU = translate(abc)                            /*   "    "   "   uppercase     "      */

x = 'alphaBETA'                                  /*define a string to a REXX variable.  */
y = translate(x,  abc || abcU,  abcU || abc)     /*swap case of  X  and store it ───► Y */
say x
say y
                                                 /*stick a fork in it,  we're all done. */
