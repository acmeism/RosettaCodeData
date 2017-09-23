/*REXX program writes a "record" (event) to the  (Microsoft)  Windows event log.        */
                                                 /* [↓]  cmd options have extra spacing.*/

'EVENTCREATE     /T  INFORMATION      /ID  234      /L  APPLICATION      /SO  REXX' ,
                '/D  "attempting to add an entry for a Rosetta Code demonstration."'

                                                 /*stick a fork in it,  we're all done. */
