/*REXX program reads and displays (with count) a file, 1 line at a time.*/
parse arg fileID .;  if fileID==''  then exit   /*No fileID?  Then stop.*/
say 'displaying file: '  fileID        /*show what file is being shown. */
call linein fileID,1,0                 /*see comment in the section hdr.*/
say                                    /* [↓]  show the file's contents.*/
     do #=1  while lines(fileID)\==0   /*loop whilst there are records. */
     x=linein(fileID);  xLen=length(x) /*read a record; get its length. */
     say                               /*show a blank for peruseability.*/
     say 'record#=' # "  length=" xLen /*show the record number & length*/
     say x                             /*show the content of the record.*/
     end    /*#*/
say
say 'file '  fileID  " has "  #-1  ' records.'   /*record count summary.*/
call lineout fileID                    /*close input file (most REXXes).*/
                                       /*stick a fork in it, we're done.*/
