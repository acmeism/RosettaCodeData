abc  = "abcdefghijklmnopqrstuvwxyz"              /*define all  lowercase  Latin letters.*/
abcU = translate(abc)                            /*   "    "   uppercase    "      "    */

x = 'alphaBETA'                                  /*define a string to a REXX variable.  */
y = translate(x)                                 /*uppercase  X  and store it ───►  Y   */
z = translate(x, abc, abcU)                      /*translate uppercase──►lowercase chars*/
