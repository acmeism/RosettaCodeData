/*REXX pgm secures (a temporary file), writes to it, displays the file, then deletes it.*/
parse arg tFID # .                               /*obtain optional argument from the CL.*/
if tFID=='' | tFID==","  then tFID= 'TEMP.FILE'  /*Not specified?  Then use the default.*/
if    #=='' |    #==","  then    #= 6            /* "      "         "   "   "     "    */
call lineout tFID                                /*insure file is closed.               */
rc= 0
say '··· creating file: '  tFID
call lineout tFID,,1                             /*insure file is open and at record 1. */
if rc\==0  then call ser rc 'creating file' tFID /*issue error if can't open the file.  */
say '··· writing  file: '  tFID

    do j=1  for #                                /*write a half-dozen records to file.  */
    call lineout tFID, 'line' j                  /*write a  record  to the file.        */
    if rc\==0  then call ser rc 'writing file'  tFID    /*Have an error?  Issue err msg.*/
    end   /*j*/

call lineout tFID                                /*close the file.                      */
say '··· reading/display file: '  tFID

    do j=1  while lines(tFID)>0                  /*read the entire file and display it. */
    x= linein(tFID)                              /*read a record from the file.         */
    if rc\==0  then call ser rc 'reading file'  tFID    /*Have an error?  Issue err msg.*/
    say 'line ' j  " of file" tFID":"  x                /*display a record to the term. */
    end   /*j*/

call lineout tFID                                /*close the file.                      */
say '··· erasing file: '  tFID
'ERASE' tFID                                     /*erase the file.                      */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ser: say; say '***error***' arg(1); say; exit 13 /*issue an error message to the term.  */
