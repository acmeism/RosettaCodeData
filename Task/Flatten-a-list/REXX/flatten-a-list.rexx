/*REXX program  (translated from PL/I)  flattens a list  (the data need not be numeric).*/
list= '[[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]'  /*the list to be flattened.    */
say list                                                 /*display the original list.   */
 c= ','                                                  /*define a literal  (1 comma). */
cc= ',,'                                                 /*   "   "    "     (2 commas).*/
list= translate(list, , "[]")                            /*translate brackets to blanks.*/
list= space(list, 0)                                     /*Converts spaces to nulls.    */
                      do  while index(list, cc) > 0      /*any double commas ?          */
                      list= changestr(cc, list, c)       /*convert  ,,  to single comma.*/
                      end   /*while*/
list= strip(list, 'T', c)                                /*strip the last trailing comma*/
list = '['list"]"                                        /*repackage the list.          */
say list                                                 /*display the flattened list.  */
