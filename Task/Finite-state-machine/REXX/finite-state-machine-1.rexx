/*REXX pgm simulates a FSM (Finite State Machine), input is recognized by pressing keys.*/
 10:  say "Press  D (deposit)   or   Q (quit)"   /*display a prompt (message) to term.  */
 20:  $=inkey();      upper $                    /*since this a terminal, uppercase KEY.*/
      if $=="D"  then signal  50                 /*Is response a "D" ?  Process deposit.*/
      if $=="Q"  then exit                       /*Is response a "Q" ?  Then exit pgm.  */
                      signal  20                 /*Response not recognized, re-issue msg*/

 50:  say "Press  S (select)    or   R (refund)" /*display a prompt (message) to term.  */
 60:  $=inkey();      upper $                    /*since this a terminal, uppercase KEY.*/
      if $=="S"  then signal  90                 /*Is response a "S" ?  Then dispense it*/
      if $=="R"  then signal 140                 /*Is response a "R" ?  Then refund it. */
                      signal  60                 /*Response not recognized? Re-issue msg*/

 90:  say "Dispensed"                            /*display what action just happened.   */
      signal 110                                 /*go and process another option.       */
                                                 /* [↑]  above statement isn't needed.  */
110:  say "Press  R (remove)"                    /*display a prompt (message) to term.  */
120:  $=inkey();      upper $                    /*since this a terminal, uppercase KEY.*/
      if $=="R"  then signal  10                 /*Is response a "R" ?  Then remove it. */
                      signal 120                 /*Response not recognized, re-issue msg*/

140:  say "Refunded"                             /*display what action just happened.   */
      signal  10                                 /*go & re-start process (ready state). */
