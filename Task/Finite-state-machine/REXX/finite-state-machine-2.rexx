/*REXX pgm simulates a FSM (Finite State Machine), input is recognized by pressing keys.*/
 10:  k=inkey('D (deposit)   or   Q (quit)','DQ')
      if k=="D"  then signal  50                 /*Is response a "D" ?  Process deposit.*/
      if k=="Q"  then exit                       /*Is response a "Q" ?  Then exit pgm.  */

 50:  k=inkey('S (select)    or   R (refund)','SR');
      if k=="S"  then signal  90                 /*Is response a "S" ?  Then dispense it*/
      if k=="R"  then signal 140                 /*Is response a "R" ?  Then refund it. */

 90:  say "Dispensed"                            /*display what action just happened.   */
      signal 110                                 /*go and process another option.       */

110:  k=inkey('R (remove)','R');
      if k=="R"  then signal  10                 /*Is response a "R" ?  Then remove it. */

140:  say "Refunded"                             /*display what action just happened.   */
      signal  10                                 /*go & re-start process (ready state). */
inkey:
Parse Arg prompt,valid
Do Forever
  Say 'Press' prompt 'and Enter'
  Parse Upper Pull key
  k=left(key,1)
  If pos(k,valid)>0 Then Leave
  Else
    Say 'Invalid key, try again.'
  End
Return k
