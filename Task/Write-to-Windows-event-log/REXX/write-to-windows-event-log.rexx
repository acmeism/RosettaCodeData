/*REXX program writes a "record" (event) to the (MS)  Windows event log.*/

    eCMD = 'EVENTCREATE'
    type = 'INFORMATION'         /*one of:  ERROR  WARNING  INFORMATION */
      id =  234                  /*in range:  1 ───►  1000  (inclusive).*/
 logName = 'APPLICATION'
  source = 'REXX'
    desc = 'attempting to add an entry for Rosetta Code demonstration.'
    desc = '"' || desc '"'       /*enclose DESCription in double quotes.*/

eCMD  '/T' type     "/ID" id     '/L' logName    "/SO" source    '/D' desc

                                 /*stick a fork in it honey, we're done.*/
