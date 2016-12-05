x = "alphaBETA"                                  /*define a string to a REXX variable.  */
y=x;   upper y                                   /*uppercase  X  and  store it ───►  Y  */
parse lower var x z                              /*lowercase  Y   "     "    " ───►  Z  */

                 /*Some REXXes don't support the  LOWER  option for the  PARSE  command.*/
