x = "alphaBETA"                                  /*define a string to a REXX variable.  */
parse upper var x y                              /*uppercase  X  and  store it ───►  Y  */
parse lower var x z                              /*lowercase  X   "     "    " ───►  Z  */

                 /*Some REXXes don't support the  LOWER  option for the  PARSE  command.*/
