/*REXX program writes a "record" (event) to the  (Microsoft)  Windows event log.        */

    eCMD = 'EVENTCREATE'                         /*name of the command that'll be used. */
    type = 'INFORMATION'                         /*one of:  ERROR  WARNING  INFORMATION */
      id =  234                                  /*in range:  1 ───►  1000  (inclusive).*/
 logName = 'APPLICATION'                         /*information about what this is.      */
  source = 'REXX'                                /*     "        "   who's doing this.  */
    desc = 'attempting to add an entry for a Rosetta Code demonstration.'
    desc = '"'  ||  desc  ||  '"'                /*enclose description in double quotes.*/

eCMD  '/T'  type       "/ID"  id       '/L'  logName       "/SO"  source       '/D'  desc

                                                 /*stick a fork in it,  we're all done. */
