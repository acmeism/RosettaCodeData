/*REXX program   reads  and  displays  (with a count)  a file,  one line at a time.     */
parse arg fID .;      if fID==''  then exit      /*Was no fileID specified?  Then quit. */
say center(' displaying file: ' fID" ", 79, '═') /*show the name of the file being read.*/
call linein fID, 1, 0                            /*see the comment in the section header*/
say                                              /* [↓]  show a file's contents (lines).*/
     do #=1  while lines(fID)\==0; y=linein(fID) /*loop whilst there are lines in file. */
     say                                         /*show a blank line for peruseability. */
     say 'record#='   #   "  length="  length(y) /*show the record number and the length*/
     say y                                       /*show the content of the line (record)*/
     end   /*#*/
say
say 'file '   fID   " has "   #-1   ' records.'  /*display the record count summary.    */
call lineout  fID                                /*close the input file  (most REXXes). */
                                                 /*stick a fork in it,  we're all done. */
