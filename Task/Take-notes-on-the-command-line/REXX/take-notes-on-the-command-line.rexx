/*REXX program implements the  "NOTES"  command (append text to a file).*/
timestamp=right(date(),11,0) time() date('W')  /*create date/time stamp.*/
nFID = 'NOTES.TXT'                     /*the fileID of the "notes" file.*/

if 'f0'x==0  then tab='05'x            /*this is an EBCDIC system.      */
             else tab='09'x            /*  "   "  "  ASCII    "         */

if arg()==0  then do while lines(nFID) /*No args?  Then show the file.  */
                  say linein(Nfid)     /*show a line of file ──► screen.*/
                  end   /*while*/
             else do
                  call lineout nFID,timestamp   /*append the timestamp. */
                  call lineout nFID,tab||arg(1) /*append the "note" text*/
                  end
                                       /*stick a fork in it, we're done.*/
