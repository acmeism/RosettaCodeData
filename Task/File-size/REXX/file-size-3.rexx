/*REXX program verifies a file's size  (by reading all the lines)  on the default mDisk.*/
parse arg iFID .                                 /*allow the user specify the  file ID. */
if iFID=='' | iFID==","  then iFID='FILESIZ DAT' /*Not specified?  Then use the default.*/
say 'size of'     iFID     "="     filesize(iFID)     'bytes'    /*on the default mDisk.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
filesize:  parse arg f;    $=0;       do  while  lines(f)\==0
                                      $=$+length(linein(f))
                                      end   /*while*/
           return $
