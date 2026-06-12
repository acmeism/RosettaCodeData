/*REXX program creates a backup file  (for a given file),  then overwrites the old file.*/
parse arg oFID .                                 /*get a required argument from the C.L.*/
if oFID==''  then do                             /*No argument?   Then issue an err msg.*/
                  say '***error*** no fileID was specified.'
                  exit 13
                  end
tFID= oFID'.$$$'                                 /*create temporary name for the backup.*/
call lineout oFID                                /*close the file  (in case it's open). */
call lineout tFID                                /*  "    "    "     "   "    "    "    */
'ERASE'  tFID                                    /*delete the backup file (if it exists)*/
'RENAME' oFID tFID                               /*rename the original file to backup.  */
call lineout oFID, '═══This is line 1.'          /*write one line to the original file. */
                                                 /*stick a fork in it,  we're all done. */
