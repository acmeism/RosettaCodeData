/*REXX program  implements the  "NOTES"  command  (append text to a file from the C.L.).*/
timestamp=right(date(),11,0)  time()  date('W')  /*create a (current) date & time stamp.*/
nFID = 'NOTES.TXT'                               /*the  fileID  of the  "notes"  file.  */

if 'f2'x==2  then tab="05"x                      /*this is an EBCDIC system.            */
             else tab="09"x                      /*  "   "  "  ASCII    "               */

if arg()==0  then do  while lines(nFID)          /*No arguments?  Then display the file.*/
                  say linein(Nfid)               /*display  a  line of file ──► screen. */
                  end   /*while*/
             else do
                  call lineout nFID,timestamp    /*append the timestamp to "notes" file.*/
                  call lineout nFID,tab||arg(1)  /*   "    "     text    "    "      "  */
                  end
                                                 /*stick a fork in it,  we're all done. */
