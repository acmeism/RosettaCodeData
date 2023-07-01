call  routineName                      /*no arguments passed to routine.*/
call  routineName  50                  /*one argument (fifty) passed.   */
call  routineName  50,60               /*two arguments        passed.   */
call  routineName  50, 60              /*(same as above)                */
call  routineName  50 ,60              /*(same as above)                */
call  routineName  10*5 , 8**4 - 4     /*(same as above)                */
call  routineName  50 , , , 70         /*4 args passed, 2nd&3rd omitted.*/
                                       /*omitted args are   NOT  null.  */
call  routineName  ,,,,,,,,,,,,,,,,800 /*17 args passed, 16 omitted.    */
call   date                            /*looks for DATE internally first*/
call  'DATE'                           /*  "    "    "  BIF | externally*/
